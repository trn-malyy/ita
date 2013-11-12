#-*- encoding: utf-8 -*-
require "trollop"
require "json"
require_relative "kadu_base"
require_relative "spec_file"
require 'net/http'
require 'watir-webdriver'
include Watir

class EpinionsPostQa < KaduBase
  attr_accessor :servers_spec,
                :test_summary

  def initialize(test_spec, test_accounts, server , report_format, title , description, dry_run, verbose, debug)
    super(test_spec, title, description, dry_run, server)
    @server_url = server
    @test_accounts = test_accounts
    @report_format = report_format
  end

  def get_test_user_details(test_type)
    test_accounts = Array.new

    accounts_spec = SpecFile.new(@test_accounts)
    case test_type
      when "Valid Login"
        accounts_spec.spec["epinions_valid_accounts"].each do |creds|
          test_accounts << creds
        end
        puts_verbose_message("valid_test_accounts = #{test_accounts}")
      when "Invalid ID Login"
        accounts_spec.spec["epinions_invalid_id"].each do |creds|
          test_accounts << creds
        end
        puts_verbose_message("invalid_id_test_accounts = #{test_accounts}")
      when "Invalid Password Login"
        accounts_spec.spec["epinions_invalid_password"].each do |creds|
          test_accounts << creds
        end
        puts_verbose_message("invalid_password_test_accounts = #{test_accounts}")
      else
        test_accounts = "Invalid test type provided #{test_type}"
    end
    test_accounts
  end

  def open_home_page()
    #Open the browser(by default FireFox)
    @ff = Watir::Browser.new
    @ff.cookies.clear
    @ff.goto(@server_url)
    @ff.title
  end

  def go_to_sign_in_page()
    @ff.link(:href => "/login/").click
    @ff.title
  end

  def user_login(creds)
    @ff.text_field(:name, "login_ID").set creds["username"]
    @ff.text_field(:name, "login_Password").set creds["password"]
    @ff.button(:name, "login_form").click
  end

  def close_browser()
    @ff.close
  end

  def format(content,format=@report_format)
    formatted_content = "\n"
    if format == 'text'
      content.each do |creds, result|
         formatted_content += <<-EOS
#{creds} -- #{result}
         EOS
      end
      formatted_content += "\n"
    elsif format == 'html'
      content.each do |creds, result|
        formatted_content += <<-EOS
        <p>
          #{creds}&nbsp;--&nbsp;<font id=#{status(result)}>#{result}</font>
        </p>
        EOS
      end
    end
    formatted_content
  end

  def validate_user_login_with_invalid_id(account_details)
    if account_details.size == 1
      account_details.each do |creds|
        user_login(creds)
        (@ff.text.include?'Invalid Epinions ID').should == true
        close_browser()
      end
    elsif account_details.size > 1
      ctr = 0
      fail = false
      result = Hash.new
      account_details.each do |creds|
        user_login(creds)
        if (@ff.text.include?'Invalid Epinions ID') == true
          result[creds] = "PASS"
        else
          result[creds] = "FAIL"
          fail = true
        end
        close_browser()
        ctr +=1
        break if ctr == account_details.size
        open_home_page()
        go_to_sign_in_page()
      end
      result = format(result)
      raise raise RSpec::Expectations::ExpectationNotMetError, result if fail == true
    end
    "Error message: Invalid ID displayed successfully"
  end

  def validate_user_login_with_invalid_password(account_details)
    if account_details.size == 1
      account_details.each do |creds|
        user_login(creds)
        (@ff.text.include?'Invalid Password').should == true
        close_browser()
      end
    elsif account_details.size > 1
      ctr = 0
      fail = false
      result = Hash.new
      account_details.each do |creds|
        user_login(creds)
        if (@ff.text.include?'Invalid Password') == true
          result[creds] = "PASS"
        else
          result[creds] = "FAIL"
          fail = true
        end
        close_browser()
        ctr +=1
        break if ctr == account_details.size
        open_home_page()
        go_to_sign_in_page()
      end
      result = format(result)
      raise raise RSpec::Expectations::ExpectationNotMetError, result if fail == true
    end
    "Error message: Invalid Password displayed successfully"
  end

  def validate_user_sign_in(account_details)
    if account_details.size == 1
      account_details.each do |creds|
        user_login(creds)
        (@ff.text.include?"| #{creds['username']}'s Account | Sign Out").should == true
        close_browser()
      end
    elsif account_details.size > 1
      ctr = 0
      fail = false
      result = Hash.new
      account_details.each do |creds|
        user_login(creds)
        if (@ff.text.include?"| #{creds['username']}'s Account | Sign Out") == true
          result[creds] = "PASS"
        else
          result[creds] = "FAIL"
          fail = true
        end
        close_browser()
        ctr +=1
        break if ctr == account_details.size
        open_home_page()
        go_to_sign_in_page()
      end
      result = format(result)
      raise raise RSpec::Expectations::ExpectationNotMetError, result if fail == true
    end
    "User was successfully Logged In"
  end

end

if (__FILE__ == $0)

  test_suite_title = "Epinions Post QA Test"

  min_report_level = 0
  max_report_level = 4
  default_report_level = 3
  default_spec_file_path = "etc/test_specs/epinions_test_specs.json"
  default_runtime_env_spec_file_path = "etc/env_specs/epinions_servers.json"
  default_accounts_spec_file_path = "etc/test_specs/epinions_accounts.json"
  default_env_credentials_spec_file_path = "../kadu_qa_core/etc/kadu_creds.json"

  opts = Trollop::options do
    banner <<-EOS
#{test_suite_title}
    #{$0} [options]
Where options are:

    EOS
    opt :test_spec, "Relative path to the test specification file ", :short => "-s", :default => default_spec_file_path
    opt :servers_spec, "Relative path to the file containing the servers", :short => "-e", :type => :string, :default => default_runtime_env_spec_file_path
    opt :test_accounts, "Relative path to the file containing test user account details", :type => :string, :default => default_accounts_spec_file_path
    opt :env_credentials_spec, "Relative path to the environment credentials specification file ", :short => "-c", :type => :string, :default => default_env_credentials_spec_file_path
    opt :title, "Report title", :short => "-t", :type => :string, :default => 'Epinions Post QA Test'
    opt :description, "Test suite description", :short => "-d", :type => :string
    opt :report_format, "Format of the output (text,html)", :short => "-f", :default => "text"
    opt :report_level, "Text report level (#{min_report_level} to #{max_report_level} most general to detailed)", :short => "-r", :type => :int, :default => default_report_level
    opt :output_report_file, "The location of the output report file.", :short => "-o", :type => :string, :required => false
    opt :dry_run, "Dry run, show what would be processed but not actually executing the test", :short => "-n" # By default the dry run value is false
    opt :verbose, "Print statements about the execution of the test during the run" # By default the verbose value is false
    opt :debug, "Print trace statements during the execution for debugging the test" # By default the debug value is false

  end

  # option validation
  Trollop::die :test_spec, "test specification file (#{opts[:test_spec]}) not found" unless (File.exists?(opts[:test_spec]))
  Trollop::die :servers_spec, "Epinion servers specification file (#{opts[:servers_spec]}) not found" unless (File.exists?(opts[:servers_spec]))
  Trollop::die :test_accounts, "Epinion test user accounts specification file (#{opts[:test_accounts]}) not found" unless (File.exists?(opts[:test_accounts]))
  Trollop::die :report_format, "invalid format (#{opts[:report_format]}), the report format must be 'text' or 'html'" unless (opts[:report_format] == 'text' or opts[:report_format] == 'html')
  Trollop::die :report_level, "invalid report level (#{opts[:report_level]}), valid levels are #{min_report_level} to #{max_report_level}" unless (min_report_level <= opts[:report_level] and opts[:report_level] <= max_report_level)

  server_list = Array.new
  if (opts[:servers_spec])
    env_spec = SpecFile.new(opts[:servers_spec])
    env_spec.spec["epinions_servers"].each do |server|
      server_list << server
    end
  else
    Trollop::die :servers_spec, "No server or servers spec defined"
  end

  test_summary = Hash.new
  test_summary[:title] = opts[:title]
  test_summary[:test_run_start_time] = Time.now
  post_qa_report = ""
  test_result_status = Hash.new
  number_of_servers = server_list.size

  server_list.each_with_index do |server, index|
    #Object creation and test execution
    pqa = EpinionsPostQa.new(opts[:test_spec], opts[:test_accounts], server, opts[:report_format], opts[:title], opts[:description], opts[:dry_run], opts[:verbose], opts[:debug])
    pqa.verbose = true if opts[:verbose]
    pqa.debug = true if opts[:debug]
    server_test_report = pqa.run
    test_result_status[server] = server_test_report[:test_suite_result_status]

    if  opts[:report_format] == "text" && index == (number_of_servers -1)
      report = pqa.build_text_report
      test_result_status.each { |s, result| post_qa_report += "#{s} | #{result}\n" }
      post_qa_report = <<-EOR
Epinions Post QA for:
#{post_qa_report}

Full report for the last server in the list:  #{server}

#{report}
      EOR
    elsif opts[:report_format] == "html" && index == (number_of_servers -1)
      report = pqa.build_html_report()
      test_summary[:test_run_end_time] = Time.now

      post_qa_report = <<-EOS
        <html>
        <body><center>
        <head><title>#{test_summary[:title]}</title></head>
        <h1 align='center'><a name="summary"><u>#{test_summary[:title]}<\/u></a><\/h1><br\/>
      EOS

      test_run_time_in_secs = Time.parse(test_summary[:test_run_end_time].to_s) - Time.parse(test_summary[:test_run_start_time].to_s)

      post_qa_report += <<-EOS
      <table id="specifications" width="500px">
        <tr><td><strong>Test Run Started On:</strong></td><td>#{test_summary[:test_run_start_time]}</td></tr>
        <tr><td><strong>Duration:</strong></td><td>#{test_run_time_in_secs} secs</td></tr>
      </table>
      <br>
      EOS

      post_qa_report += <<-EOS
          <table id="specifications" width="900px">
          <tr>
          <th >Epinions Server</th>
          <th >Test Status</th>
          </tr>
      EOS
      test_result_status.each do |server_url,status|
        post_qa_report += <<-EOS
          <tr>
          <td><a href="#{replace_space_by_dash(server_url)}">#{server_url}</a></td>
          <td><font id=#{status(status)}>#{status}</font></td>
          </tr>
        EOS
      end
      post_qa_report += <<-EOS
          </table>
        <br>
        <hr size=2 color="#000080">
        <br/>
        <h4>Detailed report for the last server in the list:  #{server}</h4>
        </center>
        <br/>
         #{report}

        </body>
        </html>
      EOS
    end

  end

  if opts[:output_report_file].nil?
    print post_qa_report
  else
    File.open(opts[:output_report_file], "w") do |report_file|
      report_file.print post_qa_report
    end
  end

end
