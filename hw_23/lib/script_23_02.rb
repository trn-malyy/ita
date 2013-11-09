 # ========================================================================
 # Script     =  script_21_02.rb
 # ========================================================================
 # Description   =  "The script in accepting path argument , reads through file 
 #                   and returns line data.
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
		my_file_lines.push var_line
	end
	#puts my_file_lines.class
	#puts my_file_lines.size
	#puts my_file_lines.length
	fruit_one = my_file_lines[0].chomp
	fruit_two = my_file_lines[1].chomp
	puts fruit_one.length
 #return the output to command line . Note.chomp method = remove new line spaces 
 puts "My favorite fruit is: #{fruit_one.chop} or #{fruit_two.chop}"
