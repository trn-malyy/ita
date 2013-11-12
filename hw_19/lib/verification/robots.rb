require 'net/http'
require 'uri'
require 'rspec'
require 'trollop'

class RobotsTest

	attr_accessor :verbose, :debug

	def initialize(domain)
		@domain = domain
    @verbose ||= false
		@debug ||= false
	end

	def puts_debug_message(message)
		$stderr.puts("DEBUG: #{message} ") if @debug
	end

	def puts_verbose_message(message)
		$stdout.puts("#{message}") if @verbose
	end

	def get_page_status_and_data(url)
    url = URI.parse(url)
    http = Net::HTTP.new(url.host, url.port)
    http.start do
      http.request_get(url.path.empty? ? "/" : url.path) do |res|
        return {:code => res.code, :body => res.body}
      end
    end
  end

  def run_robots_test()
    begin
      url = "http://#{@domain}/robots.txt"
      puts_verbose_message("Go to #{url} and get the page status code and file size.")
      status = get_page_status_and_data(url)
      puts_verbose_message("page status code: #{status[:code]} and file size: #{status[:body].size}")
      puts_verbose_message("Validate if the file exists")
      raise RSpec::Expectations::ExpectationNotMetError, "File #{url} does not exists as the page status code is #{status[:code]}, expected status code: 200" unless status[:code] == "200"
      puts_verbose_message("Validate if the file size > 0")
      raise RSpec::Expectations::ExpectationNotMetError, "Actual file size #{status[:body].size} should be greater than zero" unless status[:body].size > 0
      puts "\nPASS: The file #{url} exists with size #{status[:body].size}."
    rescue RSpec::Expectations::ExpectationNotMetError => enm
      puts "\nFAIL: #{enm.message}"
      Signal.trap('EXIT') { exit 2 }
      exit
    rescue Exception => e
      puts "\nBLOCK: #{e.message}"
      Signal.trap('EXIT') { exit 1 }
      exit
    end
  end

end


if (__FILE__ == $0)

  banner_title = File.basename($0, ".*").gsub("_", " ").split(" ").each { |word| word.capitalize! }.join(" ") + " Test"

  opts = Trollop::options do
    banner <<-EOB
#{banner_title}

    #{$0} [options]

Where options are:

    EOB

    opt :domain, "Domain name of the website", :short => "-d", :type => :string, :default => "www.shopping.com"
    opt :verbose, "Print statements about the execution of the test during the run", :short => "-v"   # By default the verbose value is false
    opt :debug, "Print trace statements during the execution for debugging the test"   # By default the debug value is false
  end

  # option validation
  Trollop::die :domain, "Domain name is missing" unless (opts[:domain])

 fe_robots_file = RobotsTest.new(opts[:domain])
 fe_robots_file.verbose = opts[:verbose]
 fe_robots_file.debug = opts[:debug]

 fe_robots_file.run_robots_test()

end