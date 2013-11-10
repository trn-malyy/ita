 # ========================================================================
 # Script     =  script_21_05.rb
 # ========================================================================
 # Description   =  "The script in accepting path as an argument, reads through file 
 #                   collects numeric values and returns in form of Ipv4.
 # Name          =  "Serhiy Malyy"
 # Email         =  "ThisIsPublicGit@nobody.com"
 # ========================================================================
require 'optparse'
require 'json'
json_file = ""
 # OptionParser is a class for command-line option analysis
 OptionParser.new do |opts| # opts is var 
  # Option one 
	opts.on("-i", "--input") do
		$file_name = ARGV[0]  # <<- GLOBAL ($) VAR a
		 #puts ARGV[0]
	end 
 end.parse!
 
	json_file = File.read($file_name)
	#puts json_file #"Class Of JSON File.Read"
	element = JSON.parse(json_file)
	#puts element.class

 #return the output to command line 
 puts "My IP Address is: #{element["octet_1"]}.#{element["octet_2"]}.#{element["octet_3"]}.#{element["octet_4"]}" 
