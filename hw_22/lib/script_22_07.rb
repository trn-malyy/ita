 # ========================================================================
 # Script     =  script_22_07.rb
 # ========================================================================
 # Description   =  "The script in accepting path as an argument, reads through file 
 #                   collects numeric values and returns average numbers
 # Name          =  "Serhiy Malyy"
 # Email         =  "ThisIsPublicGit@nobody.com"
 # ========================================================================
require 'optparse'
require 'csv'
 # OptionParser is a class for command-line option analysis
OptionParser.new do |opts| # opts is var 
  # Option one - File Path 
	opts.on("-i", "--input") do
		$file_name = ARGV[0]  # <<- GLOBAL ($) VAR a
	end 
  # Option two - Row Number 	
	opts.on("-r", "--row") do
		$row_num = ARGV[0].to_i
		#puts ARGV[0]
	end

end.parse!
	sum = ""
	$row_num = $row_num -1	
	csv_file = CSV.read($file_name)
	#puts csv_file[$row_num].class
	# spin array to calculate the summary of all option	 
	csv_file[$row_num].each do |z|
	   # puts z
		sum = sum.to_f + z.to_f
	end
 # Get the number of options 
	 num = csv_file[$row_num].length
 # calculate the average number 
	 everage = sum/num
	 #puts everage
	 #puts everage.class
 # print out the results 
  puts "The everage of the following numbers is: #{csv_file[$row_num].join(", ")} is #{everage}"