 # ========================================================================
 # Script     =  script_23_08.rb
 # ========================================================================
 # Description   =  "The script in accepting path as an argument, reads through file 
 #                   collects line values and returns them sorted
 # Name          =  "Serhiy Malyy"
 # Email         =  "ThisIsPublicGit@nobody.com"
 # ========================================================================
require 'optparse'
require 'json'
# First name last name reg EX
reg_ex = /[A-Z][a-z]/

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
	
my_file_lines = element.values.to_a
name = my_file_lines[0].match reg_ex
seasons = my_file_lines.sort.join(" ")

# return output to command line with mached first last names 
puts "Here are sorted (alphabetically) words: #{seasons} "
