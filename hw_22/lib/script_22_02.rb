 # ========================================================================
 # Script     =  script_22_02.rb
 # ========================================================================
 # Description   =  "The script in accepting path argument , reads through csv file 
 #                   and returns line data.
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
	
 #return the output to command line . Note.chomp method = remove new line spaces 
 puts "My favorite fruit is: #{csv_file[$row_num][0].chop} or  #{csv_file[$row_num][1].chop}"