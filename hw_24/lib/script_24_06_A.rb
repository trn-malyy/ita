 # ========================================================================
 # Script     =  script_21_06.rb
 # ========================================================================
 # Description   =  "The script in accepting path as an argument, reads through file 
 #                   collects numeric values and returns average numbers
 # Name          =  "Serhiy Malyy"
 # Email         =  "ThisIsPublicGit@nobody.com"
 # ========================================================================
require 'optparse'
require 'json'
sum = ""
num = ""

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

    script_name = __FILE__.split("/").to_a.last
 #	puts script_name
 #	puts element[script_name].class
 # Convert  hash values to array 
    my_vals = element[script_name].values.to_a
  
	# spin array to calculate the summary of all option	 
	my_vals.each do |z|
	   # puts z
		sum = sum.to_f + z.to_f
		#puts sum
	end
 # Get the number of options 
	 num = my_vals.length
 # calculate the average number 
	 everage = sum/num
 # print out the results 
  puts "The everage of the following numbers is: #{my_vals.join(", ")} is #{everage}"