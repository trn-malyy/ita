 # ========================================================================
 # Script     =  script_21_03.rb
 # ========================================================================
 # Description   =  "The script in accepting path as an argument, reads through file 
 #                   collects numeric value and divides one by another , then returns result .
 # Name          =  "Serhiy Malyy"
 # Email         =  "ThisIsPublicGit@nobody.com"
 # ========================================================================
require 'optparse'
 # OptionParser is a class for command-line option analysis
OptionParser.new do |opts| # opts is var 
  # Option one 
	opts.on("-i", "--input") do
		$file_name = ARGV[0]  # <<- GLOBAL ($) VAR a
		puts ARGV[0]
	end 
end.parse!
 # Empty array
	my_file_lines = []
	file = File.open($file_name, "r") # Arg "r" means read.
	file.each_line do |var_line| #<== each_line in not as string , it a collection method
 # Push is an array method , could also be done this way : my_file_lines << var_line
		my_file_lines.push var_line.chomp
	end
 #  Note.chomp method = remove new line spaces 
	num_one = my_file_lines[0]
	num_two = my_file_lines[1]
	sum = (num_one.to_i / num_two.to_i)
	
 #return the output to command line 
 puts "When I am dividing #{num_one} by #{num_two} I am always have #{sum}"
