 # ========================================================================
 # Script     =  script_22_10.rb
 # ========================================================================
 # Description   =  "The script in accepting path as an argument, reads through file 
 #                   collects line values and returns them sorted
 # Name          =  "Serhiy Malyy"
 # Email         =  "ThisIsPublicGit@nobody.com"
 # ========================================================================
require 'optparse'
require 'csv'
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
	
seasons = csv_file[$row_num].sort.join(" ")
# return output to command line with mached first last names 
puts "Here are sorted (alphabetically) words: #{seasons} "
