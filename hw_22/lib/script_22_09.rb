 # ========================================================================
 # Script     =  script_22_09.rb
 # ========================================================================
 # Description   =  "The script in accepting path as an argument, reads through file 
 #                   trying to match First Last name pattern, script will returne mached First Last name to command line 
 # Name          =  "Serhiy Malyy"
 # Email         =  "ThisIsPublicGit@nobody.com"
 # ========================================================================
require 'optparse'
require 'csv'
# First name last name reg EX
reg_ex = /[A-Z][a-z]+\s[A-Z][a-z]+/

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
	#puts csv_file[$row_num]
	name = csv_file[$row_num].join(" ")
# return output to command line with mached first last names 
puts "His name is : #{name.match reg_ex}"
