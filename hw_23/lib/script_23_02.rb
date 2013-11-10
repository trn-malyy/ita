 # ========================================================================
 # Script     =  script_23_02.rb
 # ========================================================================
 # Description   =  "The script in accepting path argument , reads through JSON file 
 #                   and returns line data.
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
	#puts element[fruit_a]
	#puts element.class
	

 #return the output to command line . Note.chomp method = remove new line spaces 
 puts "My favorite fruit is : #{element["fruits_a"].to_s.chop} or #{element["fruits_b"].to_s.chop}"
