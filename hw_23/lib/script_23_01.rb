 # ========================================================================
 # Script     =  script_21_01.rb
 # ========================================================================
 # Description   =  "The script in accepting path argument , reads through file 
 #                   and returns line data.
 # Name          =  "Serhiy Malyy"
 # Email         =  "ThisIsPublicGit@nobody.com"
 # ========================================================================
require 'optparse'
require 'jason'

 # OptionParser is a class for command-line option analysis
OptionParser.new do |opts| # opts is var 
  # Option one 
	opts.on("-i", "--input") do
		$file_name = ARGV[0]  # <<- GLOBAL ($) VAR a
		# puts ARGV[0]
	end 
end.parse!
 
	json_file = File.read($file_name)
	puts json_file.class "Class Of JSON File.Read"
	element = JASON.parse(json_file)
	puts element.class
	

 #return the output to command line . Note.chomp method = remove new line spaces 
 puts "My favorite fruits are: #{element[fruit_a]}s and #{element[fruit_b]}s"
