 # ========================================================================
 # Script     =  script_21_05.rb
 # ========================================================================
 # Description   =  "The script in accepting path as an argument, reads through file 
 #                   collects numeric values and returns average number of 5 
 # Name          =  "Serhiy Malyy"
 # Email         =  "ThisIsPublicGit@nobody.com"
 # ========================================================================
require 'optparse'
 # OptionParser is a class for command-line option analysis
OptionParser.new do |opts| # opts is var 
  # Option one 
	opts.on("-i", "--input") do
		$file_name = ARGV[0]  # <<- GLOBAL ($) VAR a
		#puts ARGV[0]
	end 
end.parse!
 # Empty array
	my_file_lines = []
	file = File.open($file_name, "r") # Arg "r" means read.
	file.each_line do |var_line| #<== each_line in not as string , it a collection method
 # Push is an array method , could also be done this way : my_file_lines << var_line
		my_file_lines.push var_line.chomp  #  Note.chomp method = remove new line spaces
	end
	
 # Format output string 	
 # Self note in order for everage_score to become float , all valuesmust be float
   everage_score = ( my_file_lines[0].to_f + my_file_lines[1].to_f + my_file_lines[2].to_f + my_file_lines[3].to_f + my_file_lines[4].to_f ) / 5.0
 
 # print out the results 
   puts "Average score of #{my_file_lines[0].to_s}, #{my_file_lines[1].to_s}, #{my_file_lines[2].to_s}, #{my_file_lines[3].to_s} and #{my_file_lines[4].to_s} is #{everage_score}"