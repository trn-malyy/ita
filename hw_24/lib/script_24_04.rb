 # ========================================================================
 # Script     =  script_22_04.rb
 # ========================================================================
 # Description   =  "The script in accepting path as an argument, reads through file 
 #                   collects numeric values and returns in form of Ipv4.
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

 #return the output to command line 
 puts "My IP Address is: #{csv_file[$row_num][0]}.#{csv_file[$row_num][1]}.#{csv_file[$row_num][2]}.#{csv_file[$row_num][3]}" 
