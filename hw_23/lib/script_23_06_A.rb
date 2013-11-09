 # ========================================================================
 # Script     =  script_21_06_A.rb
 # ========================================================================
 # Description   =  "The script in accepting path as an argument, reads through file 
 #                   collects numeric values and returns average numbers
 # Name          =  "Serhiy Malyy"
 # Email         =  "ThisIsPublicGit@nobody.com"
 # ========================================================================
require 'optparse'
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
	
	 # spin array to calculate the summary of all option	 
	my_file_lines.each do |z|
	    #puts z
		$arg_sum = (z.to_f + $arg_sum.to_f)
	 end
 # Get the number of options 
	 num = my_file_lines.length
 # calculate the average number 
	 everage = $arg_sum/num
	 #puts everage.class
 # print out the results 
  puts "The everage of the following numbers is: #{my_file_lines.join(", ")} is #{everage}"