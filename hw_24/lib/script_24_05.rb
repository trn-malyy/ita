 # ========================================================================
 # Script     =  script_24_05.rb
 # ========================================================================
 # Description   =  "The script in accepting path as an argument, reads through file 
 #                   collects numeric values and returns average number of 5 
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
	#puts element.values
	#puts element.class
  
    script_name = __FILE__.split("/").to_a.last

    my_vals = element[script_name].values.to_a
	
 # Format output string 	
 # Self note in order for everage_score to become float , all valuesmust be float
   everage_score = ( my_vals[0].to_f + my_vals[1].to_f + my_vals[2].to_f + my_vals[3].to_f + my_vals[4].to_f ) / 5.0
 
 # print out the results 
   puts "Average score of #{my_vals[0].to_s}, #{my_vals[1].to_s}, #{my_vals[2].to_s}, #{my_vals[3].to_s} and #{my_vals[4].to_s} is #{everage_score}"