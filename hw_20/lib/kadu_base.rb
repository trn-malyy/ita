require 'trollop'
require 'json'
require 'uri'
require 'cgi'
require 'nokogiri'
require 'open-uri'
require 'net/ssh'
require 'equivalent-xml'
require 'rspec/expectations'
require 'csv'
require_relative "test_spec"
require_relative "spec_file"
require_relative "env_credentials_spec"
require_relative 'kadu_exception'
require_relative 'test_report_writer'
include TestReportWriter
include RSpec::Matchers

class KaduBase
  attr_accessor :test_spec_path,
                :test_spec,
                :test_creds,
                :default_env_cred_spec_path,
                :kadu_server,
                :dry_run,
                :test_report,
                :verbose,
                :debug,
                :config_spec_path,
                :config_group


  def initialize(test_spec_path, title = nil, description = nil, dry_run = false, kadu_server=nil)
    ts = TestSpec.new(test_spec_path)
    @test_spec = ts.test_spec

    title ||= @test_spec["title"]
    description ||= @test_spec["description"]

    @test_report = Hash.new
    @test_report[:test_suite_title] = title
    @test_report[:test_suite_description] = description
    @test_report[:test_spec_path] = test_spec_path
    @kadu_server = kadu_server
    @test_report[:kadu_server] = @kadu_server
    @dry_run = dry_run
    @dynamic_params_list = Array.new
    @verbose ||= false
    @debug ||= false
    @test_report[:test_suite_start_time] = Time.now.to_s
  end

  def puts_debug_message(message)
    $stderr.puts("DEBUG: #{message} ") if @debug
  end

  def puts_verbose_message(message)
    $stdout.puts("#{message}") if @verbose
  end

  def get_test_credentials(env_cred_spec_path)
    begin
      es = SpecFile.new(env_cred_spec_path)
      test_credentials = es.spec
    rescue Exception => e
      @test_report[:test_suite_result_status] = "BLOCK"
      @test_report[:test_suite_result_mesasge] = "While getting environment credentials: #{e.message}"
    end
    test_credentials
  end

  def run(test_spec = @test_spec)
    @test_report[:test_cases] = {}

    puts_debug_message ("TRACE #{__LINE__}: test_spec test cases = #{test_spec["test_cases"].inspect}")
    test_spec["test_cases"].each do |tc_id, tc|

      puts_verbose_message("Test Case Id: #{tc_id}")

      @test_report[:test_cases][tc_id] = {}
      @test_report[:test_cases][tc_id][:title] = tc["title"] # initialize the tc_id ref
      @test_report[:test_cases][tc_id][:description] = tc["description"]
      @test_report[:test_cases][tc_id][:test_steps] = {}

      tc["test_steps"].each do |step_id, step|
        puts_verbose_message("Step id = #{step_id}")
        @test_report[:test_cases][tc_id][:test_steps][step_id] = {}

        if step.has_key?("mt_query_params")
          @mt_url = build_mt_url(@mt_server, step)
          @test_report[:test_cases][tc_id][:test_steps][step_id][:mt_url] = @mt_url

          (@mt_response, server_result) = get_server_response(@mt_url)
          if server_result['Compare (server response check)']['test_result_status'] == "BLOCK"
            @test_report[:test_cases][tc_id][:test_steps][step_id][:validation_steps] = server_result
            @test_report[:test_cases][tc_id][:test_case_result_status] = server_result['Compare (server response check)']['test_result_status']
            break
          end
        end

        if step.has_key?("query_params_template")
          @kadu_url = build_kadu_url(@kadu_server, step)
          @test_report[:test_cases][tc_id][:test_steps][step_id][:action] = @kadu_url
        end

        if step.has_key?("query_params")
          @kadu_url = build_kadu_url(@kadu_server, step)
          @test_report[:test_cases][tc_id][:test_steps][step_id][:action] = @kadu_url

          (@kadu_response, server_result) = get_server_response(@kadu_url)
          if server_result['Compare (server response check)']['test_result_status'] == "BLOCK"
            @test_report[:test_cases][tc_id][:test_steps][step_id][:validation_steps] = server_result
            @test_report[:test_cases][tc_id][:test_case_result_status] = server_result['Compare (server response check)']['test_result_status']
            break
          end
  # code to get the server info for each test case for the test report
          if !@dry_run
            @test_report[:test_cases][tc_id][:server_info] = {}
            #@test_report[:test_cases][tc_id][:server_info][:country_id] = @kadu_response.xpath("/kadu-response/server/country_id").text
            #@test_report[:test_cases][tc_id][:server_info][:lang_id] = @kadu_response.xpath("/kadu-response/server/lang_id").text
            #@test_report[:test_cases][tc_id][:server_info][:db] = @kadu_response.xpath("/kadu-response/server/database").text
            @test_report[:test_cases][tc_id][:server_info][:kadu_branch] = @kadu_response.xpath("//kadu-response/server/kadu-branch").text
            @test_report[:test_cases][tc_id][:server_info][:kadu_version] = @kadu_response.xpath("//kadu-response/server/kadu-version").text
            @test_report[:test_cases][tc_id][:server_info][:kadu_index] = @kadu_response.xpath("//kadu-response/server/kadu-index-info").text
          end
        end

        if step.has_key?("test_params")
          @test_params = {}
          @test_params = step["test_params"]
        end

        if step.has_key?("dynamic_params")
          begin
            @test_report[:test_cases][tc_id][:test_steps][step_id][:dynamic_params] = process_dynamic_params(step["dynamic_params"])
            raise Exception if @test_report[:test_cases][tc_id][:test_steps][step_id][:dynamic_params].to_s.include?("BLOCK")
          rescue Exception => e
            @test_report[:test_cases][tc_id][:test_case_result_status] = "BLOCK"
            puts_verbose_message("#{e.message}")
            break
          end
        end

        if step.has_key?("validation_steps")

          validation_results = validate_response(@kadu_response, step)
          @test_report[:test_cases][tc_id][:test_steps][step_id][:validation_steps] = validation_results
          @test_report[:test_cases][tc_id][:test_case_result_status] = summarize_test_case_result_status(validation_results)
          break if (@test_report[:test_cases][tc_id][:test_case_result_status] == "FAIL" or @test_report[:test_cases][tc_id][:test_case_result_status] == "BLOCK")

        end

      end
    end
    puts_verbose_message("#{"#".*(60)}\n\n")
    @test_report[:test_suite_result_status] = summarize_test_suite_result_status(@test_report[:test_cases])
    @test_report[:test_suite_completed_time] = Time.now.to_s
    @test_report
  end

  def summarize_test_suite_result_status(test_cases_report)
    test_suite_result_status = ""
    test_cases_report.each do |test_case_id, test_case|
      if (@dry_run)
        test_suite_result_status = "DRY-RUN"
      elsif (test_case[:test_case_result_status] == "BLOCK")
        test_suite_result_status = "BLOCK"
      elsif (test_case[:test_case_result_status] == "FAIL" and test_suite_result_status != "BLOCK")
        test_suite_result_status = "FAIL"
      elsif (test_case[:test_case_result_status] == "INFO")
        test_suite_result_status = "INFO" unless (test_suite_result_status == "BLOCK" or test_suite_result_status == "FAIL")
      elsif (test_case[:test_case_result_status] == "PASS")
        test_suite_result_status = "PASS" unless (test_suite_result_status == "BLOCK" or test_suite_result_status == "FAIL" or test_suite_result_status == "INFO")
      else
        test_suite_result_status = test_case[:test_case_result_status]
      end
    end

    test_suite_result_status
  end

  def summarize_test_case_result_status(validation_results)
    test_case_result_status = ""
    validation_results.each do |validation_step, test_result|
      if (@dry_run)
        test_case_result_status = "DRY-RUN"
      elsif (test_result["test_result_status"] == "BLOCK")
        test_case_result_status = "BLOCK"
      elsif (test_result["test_result_status"] == "FAIL" and test_case_result_status != "BLOCK")
        test_case_result_status = "FAIL"
      elsif (test_result["test_result_status"] == "INFO" )
        test_case_result_status = "INFO" unless (test_case_result_status == "BLOCK" or test_case_result_status == "FAIL")
      elsif (test_result["test_result_status"] == "PASS" )
        test_case_result_status = "PASS" unless (test_case_result_status == "BLOCK" or test_case_result_status == "FAIL" or test_case_result_status == "INFO")
      else
        test_case_result_status = test_result["test_result_status"]
      end
    end
    test_case_result_status
  end

  def process_dynamic_params(dynamic_params)
    dynamic_params_report = Hash.new
    dynamic_params.each do |parameter_name, parameter_expression|
      parameter_value = evaluate_parameter_expression(parameter_expression)
      self.instance_variable_set("@#{parameter_name.gsub(/^@/, "")}", parameter_value)
      parameter_value = "XML document " if parameter_value.class.to_s.include?("XML")
      dynamic_params_report[parameter_name] = {parameter_expression => parameter_value.to_s}
      @dynamic_params_list << parameter_name
      puts_debug_message("TRACE (#{__LINE__} ) : value for #{parameter_name} = #{self.instance_variable_get("@#{parameter_name}")} ")
    end

    dynamic_params_report
  end

  def evaluate_parameter_expression(parameter_expression)
    result = nil
    if @dry_run
      result = "DRY-RUN"
    else
      begin
        parameter_expression.match(/(\S+)\s+(.*)/)
        parameter_type = $1 # get the first matching pattern
        parameter_statement = $2 # get the second matching pattern
        if parameter_type == "xpath"
          node = @kadu_response.xpath(parameter_statement)
          if (node.children.size == 1)
            result = node.children.to_s
          else
            result = node.children
          end
        elsif (parameter_type == "call")
          result = eval(parameter_statement)
        elsif (parameter_type == "set")
          result = eval(parameter_statement)
        end
      rescue KaduError => kemsg
        result = "Test BLOCK:#{kemsg}"
      rescue Exception => e
        result = "BLOCK:#{e}"
      end
    end
    result
  end

#note we should be able to report what values where in the comparison
  def get_values_for_test_result_message(expectation_statement)
    test_result_message = ""
    if (expectation_statement.include?("EquivalentXml.equivalent"))
      value = expectation_statement.split('==')
      value[0] = value[1]
      expectation_statement = "#{value[0]} == #{value[1]}"
    else
      @dynamic_params_list.each do |param|
        if /@#{param}\b/.match(expectation_statement)                  #expectation_statement.include?("@#{param}")
          param_value = eval("@#{param}")
          value_class = param_value.class
          value_class = value_class.to_s
          if value_class == "Array"
            value = ""
            param_value.each { |element| value << element.to_s + "," }
            param_value = value.to_s.chop
          else
            param_value = param_value.to_s
          end
          expectation_statement = expectation_statement.gsub(/@#{param}/, param_value)
        end
      end
    end
    expectation_statement
  end

  def get_host_from_url(url)
    uri = URI.parse(url)
    uri.host
  end

  def simple_db_exec(sql_statement)
    raise "No database connection_string configured" if @db_connection_string.nil?
    result_set = Array.new
    begin
      conn = OCI8.new(@db_connection_string)
      row_count = conn.exec(sql_statement) do |row|
        result_set << row
        break
      end
      conn.logoff
    rescue Exception => e
      raise Exception, "Error in executing sql statement - #{sql_statement}: #{e.message}"
    end
    result_set[0]
  end

  # Should be called when the connection is made to the server
  def check_if_server_file_exists(ssh, server_file)
    file = ssh.exec!("[ -f #{server_file} ] && echo 'File exists' || echo 'File does not exists'")
    if (file.include?("File does not exists"))
      test_result_status = "BLOCK"
      test_result_message = "#{server_file} does not exist on the server"
    else
      test_result_status = "PASS"
      test_result_message = "#{server_file} exists on the server"
    end
    test_result = {"test_result_status" => test_result_status, "test_result_message" => test_result_message}
    test_result
  end

  def validate_response(kadu_response = @kadu_response, test_step = nil)
    validation_results = Hash.new

    test_step["validation_steps"].each do |criteria, expected_result|
      test_result = Hash.new
      test_result_status = ""
      test_result_message = ""
      if (@dry_run)
        test_result_status = "DRY-RUN"
        test_result_message = "The test would evaluate if #{criteria} == #{expected_result}"
      else
        if expected_result == "true"
          expected_result = true
        elsif expected_result == "false"
          expected_result = false
        end

        begin

          if (criteria.match(/^Compare\s*/))
            eval(expected_result)
            test_result_message = get_values_for_test_result_message(expected_result) + ", "
            raise Exception, test_result_message if test_result_message.include?("BLOCK")
          elsif (criteria.match(/^Check\s*/))
            test_result_message = eval(expected_result)
            test_result_message += ", "
          else
            xpath_result = kadu_response.xpath(criteria)
            xpath_result.should == expected_result
          end

          test_result_message = test_result_message + "#{criteria} == #{expected_result}"
          test_result_status = "PASS"

        rescue RSpec::Expectations::ExpectationNotMetError => nme
          test_result_status = "FAIL"
          test_result_message = nme.message
          test_result = {"test_result_status" => test_result_status, "test_result_message" => test_result_message}
          validation_results[criteria] = test_result
          break
        rescue Exception => e
          test_result_status = "BLOCK"
          test_result_message = e.message
          test_result = {"test_result_status" => test_result_status, "test_result_message" => test_result_message}
          validation_results[criteria] = test_result
          break
        end
      end
      test_result = {"test_result_status" => test_result_status, "test_result_message" => test_result_message}

      validation_results[criteria] = test_result
    end
    validation_results
  end

  def get_server_response(uri)
    test_result_status = ""
    test_result_message = ""
    if (@dry_run)
      response = Object.new
      test_result_status = "DRY-RUN"
      test_result_message = "The test would fetch the Kadu data"
      test_result = {"Compare (server response check)" => {"test_result_status" => test_result_status, "test_result_message" => test_result_message}}
      return [response, test_result]
    else
      begin
        response = Nokogiri::XML(open(uri))
        test_result_status = "PASS"
        test_result_message = "Successfully gotten server response"
      rescue Exception => e
        test_result_status = "BLOCK"
        test_result_message = e.message
      end
      test_result = {"Compare (server response check)" => {"test_result_status" => test_result_status, "test_result_message" => test_result_message}}
      return [response, test_result]
    end

  end

  def build_mt_url(mt_server=@mt_server, test_step=nil)

    url = mt_server
    url = url + "/?" unless (url.include?("/?"))

    test_step["mt_query_params"].each do |k, v|
      v = v.to_s
      v = "" if v.nil?
      @dynamic_params_list.each do |param|
        if /@#{param}\b/.match(v) #v.include?("@#{param}")
          param_value = eval("@#{param}")
          value_class = param_value.class
          value_class = value_class.to_s
          if value_class == "Array"
            value = ""
            param_value.each { |element| value << element.to_s + "," }
            param_value = value.to_s.chop
          else
            param_value = param_value.to_s
          end
          #$stderr.puts("TRACE: #{__LINE__} : param = #{param} param eval = #{eval("@#{param}")}, param_value = #{param_value} query_params config v = #{v}")
          v.gsub!(/@#{param}/, CGI.escape(param_value))
        end
      end
      url = url + "#{k}=#{CGI.escape(v.to_s)}&"
      url = url.gsub(/\s+/, '')
    end
    puts_debug_message("Mt_URL = #{url}")
    url
  end

  def build_kadu_url(kadu_server=@kadu_server, test_step=nil)

    raise "kadu_server is nil" if kadu_server.nil?
    raise "test_step is nil" if test_step.nil?
    url = kadu_server
    url = url + "/?" unless (url.include?("/?"))

    query_params = Hash.new
    if test_step.key?("query_params")
      query_params = test_step["query_params"]
    elsif test_step.key?("query_params_template")
      query_params = test_step["query_params_template"]
    end

    query_params.each do |k, v|
      v = v.to_s
      v = "" if v.nil?
      @dynamic_params_list.each do |param|
        if /@#{param}\b/.match(v)  #v.include?("@#{param}")
          param_value = eval("@#{param}")
          value_class = param_value.class
          value_class = value_class.to_s
          if value_class == "Array"
            value = ""
            param_value.each { |element| value << element.to_s + "," }
            param_value = value.to_s.chop
          else
            param_value = param_value.to_s
          end
          #$stderr.puts("TRACE: #{__LINE__} : param = #{param} param eval = #{eval("@#{param}")}, param_value = #{param_value} query_params config v = #{v}")
          v.gsub!(/@#{param}/,param_value)
        end
      end
      if k == 'query'
        url = url + "#{k}=#{CGI.escape(v.to_s)}&"
      else
        if v.to_s.include?(' ')
          url = url + "#{k}=#{CGI.escape(v.to_s)}&"
        else
          url = url + "#{k}=#{v.to_s}&"
        end
      end
    end
    url
  end

  def switch_composer_flag_url(url)
    if url.include?("composer.xml()")
      return_url = url.gsub("composer.xml()", "composer.xml(1)")
    elsif url.include?("composer.xml(1)")
      return_url = url.gsub("composer.xml(1)", "composer.xml()")
    else
      raise KaduError "Trying to turn on composer feature for url with no composer feature specified #{url}"
    end
    return_url
  end

  def turn_on_composer_url(url)
    switch_composer_flag_url(url)
  end

  def turn_off_composer_url(url)
    switch_composer_flag_url(url)
  end

  def merchant_id_from_merchant_ref(kadu_response = @kadu_response, merchant_ref=nil)
    raise "merchant_ref is nil" if merchant_ref.nil?
    xref = 0
    merchant_id = ""
    merchant_id = kadu_response.xpath("//merchants[1]/merchant[@xref='#{CGI.escape(merchant_ref)}']/id").inner_text
    merchant_id
  end

  def build_minimal_text_report(test_report = @test_report)
    report = level_0_text_report(test_report)
    report
  end

  def build_text_report(test_report = @test_report, extra_report_header = nil)
    report = text_report(test_report, extra_report_header)
    report
  end

  def build_json_report(test_report = @test_report)
    report = json_report(test_report)
    report
  end

  def build_html_report(test_report = @test_report, extra_report_header = nil)
    report = html_report(test_report, extra_report_header)
    report
  end

end

if (__FILE__ == $0)
  $stderr.puts "#{__FILE__} is a Base class"
  exit -1
end