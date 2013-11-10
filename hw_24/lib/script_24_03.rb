 # ========================================================================
 # Script     =  script_22_03.rb
 # ========================================================================
 # Description   =  "The script in accepting path as an argument, reads through csv file 
 #                   collects numeric value and divides one by another , then returns result .
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

	$row_num = $row_num -1
	
	csv_file = CSV.read($file_name)

    #	puts csv_file.class
	#	puts csv_file.size
	#	puts csv_file
 #  Note.chomp method = remove new line spaces 
	num_one = csv_file[$row_num][0]
	num_two = csv_file[$row_num][1]
	sum = (num_one.to_i / num_two.to_i)
	
 #return the output to command line 
 puts "When I am dividing #{num_one} by #{num_two} I am always have #{sum}"

