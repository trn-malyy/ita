 # ========================================================================
 # Script     =  script_21_05.rb
 # ========================================================================
 # Description   =  "The script in accepting path as an argument, reads through file 
 #                   collects numeric values and returns average number of 5 
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
 # Empty array

	$row_num = $row_num -1
	
	csv_file = CSV.read($file_name)
	
 # Format output string 	
 # Self note in order for everage_score to become float , all valuesmust be float
   everage_score = ( csv_file[$row_num][0].to_f + csv_file[$row_num][1].to_f + csv_file[$row_num][2].to_f + csv_file[$row_num][3].to_f + csv_file[$row_num][4].to_f ) / 5.0
 
 # print out the results 
   puts "Average score of #{csv_file[$row_num][0].to_s}, #{csv_file[$row_num][1].to_s}, #{csv_file[$row_num][2].to_s}, #{csv_file[$row_num][3].to_s} and #{csv_file[$row_num][4].to_s} is #{everage_score}"