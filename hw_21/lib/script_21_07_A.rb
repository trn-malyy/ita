 # ========================================================================
 # Script     =  script_21_07_A.rb
 # ========================================================================
 # Description   =  "The script in accepting path as an argument, reads through file 
 #                   trying to match First Last name pattern, script will returne mached First Last name to command line 
 # Name          =  "Serhiy Malyy"
 # Email         =  "ThisIsPublicGit@nobody.com"
 # ========================================================================
require 'optparse'
# First name last name reg EX
reg_ex = /[A-Z][a-z]+\s[A-Z][a-z]+/

 # OptionParser is a class for command-line option analysis
OptionParser.new do |opts| # opts is var 
  # Option one 
	opts.on("-i", "--input") do
		$file_name = ARGV[0]  # <<- GLOBAL ($) VAR a
		#puts ARGV[0]
	end 
end.parse!
 # Empty array
	my_file_lines = []
	file = File.open($file_name, "r") # Arg "r" means read.
	file.each_line do |var_line| #<== each_line in not as string , it a collection method
 # Push is an array method , could also be done this way : my_file_lines << var_line
		my_file_lines.push var_line.chomp  #  Note.chomp method = remove new line spaces
		#puts my_file_lines.size
	end
	
name = my_file_lines[0].match reg_ex
# return output to command line with mached first last names 
puts "His name is : \"#{name}\""
