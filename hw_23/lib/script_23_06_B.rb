 # ========================================================================
 # Script     =  script_23_06_B.rb
 # ========================================================================
 # Description   =  "The script in accepting path as an argument, reads through file 
 #                   collects numeric values and returns average of numbers
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

	my_file_lines = []
	my_file_lines = element.values.to_a

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