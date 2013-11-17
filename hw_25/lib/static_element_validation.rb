require 'mechanize'
require 'json'
require 'cgi'
require 'trollop'
require 'net/smtp'
require_relative '../common/test_spec'
require_relative '../common/log_file'
include LogFile

$MODULE_DIR = File.expand_path(File.dirname(__FILE__)).gsub(/lib/, '')
puts $MODULE_DIR

class FEStaticElementTest

	attr_accessor :verbose, :debug

	def initialize(domain, page_spec_path, common_elements, common_element_spec_path, exitstatus, smtp_server, email_log)
		@domain = domain
    @domain = "http://#{domain}" if !domain.include?("http://")
	puts "Domain value is: #{@domain}"
    @verbose ||= false
		@debug ||= false
    @page_details = TestSpec.new(page_spec_path).test_spec
    @common_elements = TestSpec.new(common_element_spec_path).test_spec
		puts " common_elements data type is : #{@common_elements.class}"
		puts " common_elements value is : #{@common_elements}"
    @exitstatus = exitstatus
	puts " exitstatus value is : #{@exitstatus}"
    @common_elements_mode = common_elements
    @smtp_server = smtp_server
    @email_log = email_log
	#puts "about to call get log file path"
    @log_file = get_logfile_path() if @exitstatus
	puts "log_file value  is #{@log_file}"
    @report = ""
    @test_name = File.basename($0, ".*").gsub("_", " ").split(" ").each { |word| word.capitalize! }.join(" ")
	puts "test_namevalue  is #{@test_name}"
  end

  def puts_debug_message(message)
		$stderr.puts("DEBUG: #{message} ") if @debug
	end

	def puts_verbose_message(message)
		$stdout.puts("#{message}") if @verbose
  end

  def get_logfile_path()
  
  pust "inside of get_logfile_path"
    if !File.directory?(File.join($MODULE_DIR,'log'))
      Dir.mkdir(File.join($MODULE_DIR,'log'))
      File.chmod(0777, File.join($MODULE_DIR,'log'))
    end
    timestamp = Time.now.strftime('%Y-%m-%d-%H-%M-%S')
    file_name = "#{File.basename( __FILE__, ".*" )}-#{timestamp}.log"
    file_path = File.join($MODULE_DIR,'log',file_name)
    file_path
  end

  def get_web_page_content(url)
      begin
          page_data = {}
          page_data[:agent]= Mechanize.new
          page_data[:page]= page_data[:agent].get(url)
          page_data[:code]= page_data[:page].code
          page_data[:body]= page_data[:page].body
          page_data[:status] = "PASS"
      rescue Exception => e
          page_data[:status] = "BLOCK: #{e.message}"
      end
      page_data
  end

  def verify_page_elements(page_elements, page_id, page)
    page_elements['elements'].each do |element_details|
        if element_details['element_name'].empty?
          puts_debug_message "No element details provided for #{element_details['element_id']}."
          next
        end
        puts_debug_message("Element ID: #{element_details['element_id']}\tElement Name: <#{element_details['element_name']}>")
        @report += <<-EOR
Element: #{element_details['element_id']} : <#{element_details['element_name']}>

Validations:
                      EOR
        page.parser.xpath("//#{element_details['element_name']}").to_s
        element_data = page.parser.xpath("//#{element_details['element_name']}").to_s
        puts_debug_message("Element data: #{element_data}")
        if element_data.empty?
          puts_verbose_message "Page ID : #{page_id} - Element ID:#{element_details['element_id']}"
          @report += <<-EOR
 FAIL: The element does not exist.
                EOR
          if @exitstatus
            File.open(@log_file, "w+"){ |file| file.print @report }
            send_log_email(@smtp_server,@report,@test_name,@log_file) if @email_log
            Signal.trap('EXIT') { exit 2 }
            exit
          end
        else
          element_occurrence_count = page.body.scan(/<#{element_details['element_name']}/).size
          @report += <<-EOR
 PASS: Element exists and the occurrence count: #{element_occurrence_count}
                      EOR
          if element_details['element_value'].empty?
             puts_debug_message "For element #{element_details['element_name']}, no value provided."
          else
            if !element_details['selector'].empty?
              element_xpath = "//#{element_details['element_name']}[@#{element_details['selector']}=\"#{element_details['selector_value']}\"]"
              data = page.parser.xpath(element_xpath).to_s.force_encoding("UTF-8")
              actual_element_value = data.slice(/(?<=^|>)[^><]+?(?=<|$)/).to_s.strip
            else
              actual_element_value = element_data.slice(/(?<=^|>)[^><]+?(?=<|$)/).to_s
            end
            expected_element_value = element_details['element_value'].force_encoding('UTF-8')
            puts_debug_message("Element value -- actual:#{actual_element_value} and expected:#{expected_element_value}")

            if expected_element_value == '*'
              if actual_element_value.size > 0
                @report += <<-EOR
 PASS: Element value exist and not NIL.
                      EOR
              else
                @report += <<-EOR
 FAIL: Element value is NIL; expected element value should not be NIL.
                      EOR
                puts_verbose_message "Page ID : #{page_id} - Element ID:#{element_details['element_id']}"
                if @exitstatus
                  File.open(@log_file, "w+"){ |file| file.print @report }
                  send_log_email(@smtp_server,@report,@test_name,@log_file) if @email_log
                  Signal.trap('EXIT') { exit 2 }
                  exit
                end
              end
            else
              if actual_element_value != expected_element_value
                @report += <<-EOR
 FAIL: The '#{element_details['element_name']}' values do not match;
       Expected: #{expected_element_value}
       Actual: #{actual_element_value}
                      EOR
                puts_verbose_message "Page ID : #{page_id} - Element ID:#{element_details['element_id']}"
                if @exitstatus
                  File.open(@log_file, "w+"){ |file| file.print @report }
                  send_log_email(@smtp_server,@report,@test_name,@log_file) if @email_log
                  Signal.trap('EXIT') { exit 2 }
                  exit
                end
              else
                @report += <<-EOR
 PASS: Element value matches the expected value.
                      EOR
              end
            end
          end
          if element_details['attributes'].nil? or element_details['attributes'].empty?
             puts_debug_message "For element #{element_details['element_name']}, no attributes provided."
          else
            element_details["attributes"].each do |attribute|
               puts_debug_message("Attribute ID: #{attribute['attribute_id']}\tAttribute Name: #{attribute['attribute_name']}")
               @report += <<-EOR

 Attribute: #{attribute['attribute_id']} : #{attribute['attribute_name']}

                      EOR
               attribute_data = "//#{element_details['element_name']}/@#{attribute['attribute_name']}"
               attribute_detail = page.parser.xpath(attribute_data).to_s
               puts_debug_message("Attribute data: #{attribute_detail}")
               if attribute_detail.empty?
                 puts_verbose_message "Page ID : #{page_id} - Element ID:#{element_details['element_id']} - Attribute ID: #{attribute['attribute_id']}"
                  @report += <<-EOR
  FAIL: The attribute '#{attribute['attribute_name']}' does not exist.
                            EOR
                  if @exitstatus
                    File.open(@log_file, "w+"){ |file| file.print @report }
                    send_log_email(@smtp_server,@report,@test_name,@log_file) if @email_log
                    Signal.trap('EXIT') { exit 2 }
                    exit
                  end
               else
                 @report += <<-EOR
  PASS: The attribute '#{attribute['attribute_name']}' exist.
                           EOR
                 if attribute['attribute_value'].empty?
                   puts_debug_message "For attribute #{attribute['attribute_name']}, no value provided."
                 else
                   attribute_xpath = "//#{element_details['element_name']}[@#{attribute['attribute_name']}=\"#{attribute['attribute_value']}\"]"
                   data = page.parser.xpath(attribute_xpath).to_s.force_encoding("UTF-8")
                   puts_debug_message("Attribute value details -- #{data}")
                   if data.include?(attribute['attribute_value'])
                     actual_attribute_value = data.match(/#{attribute['attribute_name']}="(.*?)"/)[1].to_s.strip
                   else
                     actual_attribute_value = page.parser.xpath(attribute_data).to_a
                   end
                   expected_attribute_value = attribute['attribute_value'].force_encoding('UTF-8')
                   puts_debug_message("Attribute value -- actual:#{actual_attribute_value} and expected:#{expected_attribute_value}")
                   if expected_attribute_value == '*'
                     if actual_attribute_value.size > 0
                        @report += <<-EOR
  PASS: attribute '#{attribute['attribute_name']}' value exist and not NIL.
                                  EOR
                     else
                       puts_verbose_message "Page ID : #{page_id} - Element ID:#{element_details['element_id']} - Attribute ID: #{attribute['attribute_id']}"
                       @report += <<-EOR
  FAIL: attribute '#{attribute['attribute_name']}' value does not exist and is NIL; expected attribute value should exist and not be NIL.
                                  EOR
                        if @exitstatus
                          File.open(@log_file, "w+"){ |file| file.print @report }
                          send_log_email(@smtp_server,@report,@test_name,@log_file) if @email_log
                          Signal.trap('EXIT') { exit 2 }
                          exit
                        end
                     end
                   else
                      if actual_attribute_value != expected_attribute_value
                        @report += <<-EOR
  FAIL: The attribute '#{attribute['attribute_name']}' values do not match;
        Expected: #{expected_attribute_value}
        Actual: Following values were obtained for the attribute:
                                  EOR
                actual_attribute_value.each {|x|
                        @report += <<-EOR
                #{x.to_s}
                                  EOR
                        }
                        puts_verbose_message "Page ID : #{page_id} - Element ID:#{element_details['element_id']} - Attribute ID: #{attribute['attribute_id']}"
                        if @exitstatus
                          File.open(@log_file, "w+"){ |file| file.print @report }
                          send_log_email(@smtp_server,@report,@test_name,@log_file) if @email_log
                          Signal.trap('EXIT') { exit 2 }
                          exit
                        end
                      else
                        @report += <<-EOR
  PASS: Attribute '#{attribute['attribute_name']}' value matches the expected value.
                                  EOR
                      end
                    end
                 end
              end
            end
          end
        end
        @report += <<-EOR
#{"-"*120}
                  EOR
      end
    @report
  end

  def verify_common_elements(common_elements, page_id, page)
      @report += <<-EOR
Common Elements:
#{"_"*120}
         EOR
      puts_verbose_message("Validating Common Elements")
      verify_page_elements(common_elements, page_id, page)
  end

  def verify_page_specific_elements(page_elements, page_id, page, page_details)
    @report += <<-EOR

#{page_details['page_name']} Elements:
#{"_"*120}
         EOR
     puts_verbose_message("Validating #{page_details['page_name']} Elements")
     verify_page_elements(page_elements, page_id, page)
     @report
  end

  def run_static_web_element_verification()
    pg_specs = []
    @report += <<-EOR

FE Static Element Validation

        EOR

    @page_details['pages'].each do |page_detail|
      page_url = "#{@domain}#{page_detail['page_url']}"
      pg_specs << page_detail['page_spec'].size

      if !(page_detail['page_spec'].empty? and @common_elements_mode == false)
      @report += <<-EOR
#{"="*120}
PAGE: #{page_detail['page_id']} : #{page_url}
#{"="*120}

                  EOR
      end
      puts_verbose_message("PAGE: #{page_detail['page_id']} : #{page_url}")
      puts_debug_message("PAGE: #{page_detail['page_id']} : #{page_url}")
      page_data = get_web_page_content(page_url)
      puts_verbose_message("Web page status: #{page_data[:status]}")
      puts_debug_message("Web page status: #{page_data[:status]}")
      page = page_data[:page]
      if page_data[:status] == "PASS"
        #verify common elements
        verify_common_elements(@common_elements, page_detail['page_id'], page) if @common_elements_mode

        if !page_detail['page_spec'].empty?
          page_elements = TestSpec.new(File.join($MODULE_DIR,"etc","test_specs","page_specs",page_detail['page_spec'])).test_spec
          #verify page specific elements if any
          verify_page_specific_elements(page_elements, page_detail['page_id'], page, page_detail)
        end
      else
        puts_debug_message page_data[:status]
        @report += <<-EOR
#{page_data[:status]}

                  EOR
        if @exitstatus
          File.open(@log_file, "w+"){ |file| file.print @report }
          send_log_email(@smtp_server,@report,@test_name,@log_file) if @email_log
          Signal.trap('EXIT') { exit 1 }
          exit
        end
      end
    end

    if pg_specs.uniq[0] == 0 and pg_specs.uniq.size == 1 and @common_elements_mode == false
      puts_debug_message "BLOCK: There are no page specific elements provided for testing all the pages when the 'Common Elements Mode' is enabled."
      @report += <<-EOR
BLOCK: There are no page specific elements provided for testing all the pages when the 'Common Elements Mode' is enabled.
                  EOR
        if @exitstatus
          File.open(@log_file, "w+"){ |file| file.print @report }
          send_log_email(@smtp_server,@report,@test_name,@log_file) if @email_log
          Signal.trap('EXIT') { exit 1 }
          exit
        end
    end
    puts_verbose_message("Test completed successfully")
    @report
   end
end

if (__FILE__ == $0)

  banner_title = File.basename($0, ".*").gsub("_", " ").split(" ").each { |word| word.capitalize! }.join(" ") + " Test"
  puts banner_title
  default_output_report_file = File.join($MODULE_DIR,'reports','sdc_static_element_verification_report.txt')
  default_test_spec_file = File.join($MODULE_DIR,'etc','test_specs','sdc_page_urls.json')
  default_common_element_spec_file = File.join($MODULE_DIR,'etc','test_specs','common_elements.json')

  opts = Trollop::options do
    banner <<-EOB
#{banner_title}

    #{$0} [options]

Where options are:

    EOB

    opt :domain, "Domain name of the website", :short => "-d", :type => :string, :default => "www.shopping.com"
    opt :test_spec, "Relative path to the test specification file ", :short => "-p", :type => :string, :default => default_test_spec_file
    opt :common_elements, "When enabled, checks each page for the common elements; when disabled will not check common elements tests", :short => "-c", :default => true
    opt :common_elements_spec, "Relative path to the common page elements specification file ", :short => "-s", :type => :string, :default => default_common_element_spec_file
    opt :exitstatus, "Mode of execution; when enabled will exit the test if the any test fails providing the appropriate exit code", :short => "-m", :required => false
    opt :output_report_file, "The location of the output text report file; ignored in exitstatus", :short => "-o", :type => :string, :default => default_output_report_file
    opt :verbose, "Print statements about the execution of the test during the run; ignored in exitstatus", :short => "-v", :required => false   # By default the verbose value is false
    opt :debug, "Print trace statements during the execution for debugging the test; ignored in exitstatus", :required => false   # By default the debug value is false
    opt :email_log, "Sends email with the log @report in exitstatus mode in case of a failure.", :short => "-l", :default => false
    opt :smtp_server, "Provide SMTP server to be used for sending email", :type => :string, :default => 'mail.dealtime.com'
  end

  # option validation
  Trollop::die :domain, "Domain name is missing" unless (opts[:domain])
  Trollop::die :test_spec, "test specification file (#{opts[:test_spec]}) not found" unless (File.exists?(opts[:test_spec]))
  Trollop::die :common_elements_spec, "test specification file (#{opts[:common_elements_spec]}) not found" unless (File.exists?(opts[:common_elements_spec]))
  Trollop::die :smtp_server, "SMTP server is missing" unless (opts[:smtp_server])

  fe_static_element_test = FEStaticElementTest.new(opts[:domain],opts[:test_spec], opts[:common_elements], opts[:common_elements_spec], opts[:exitstatus],opts[:smtp_server],opts[:email_log])
  if opts[:exitstatus] == false
      fe_static_element_test.verbose = opts[:verbose]
      fe_static_element_test.debug = opts[:debug]
  end
  test_report = fe_static_element_test.run_static_web_element_verification()

  if opts[:exitstatus] == false
    if opts[:output_report_file].nil? or opts[:output_report_file].empty?
      print test_report
    else
      if !File.directory?(File.join($MODULE_DIR,'reports'))
        Dir.mkdir(File.join($MODULE_DIR,'reports'))
        File.chmod(0777, File.join($MODULE_DIR,'reports'))
      end
      File.open(opts[:output_report_file], "w") do |report_file|
        report_file.print test_report
      end
    end
  end
end