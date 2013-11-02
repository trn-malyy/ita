 # ========================================================================
 # Script        =   script_17_05.rb
 # ========================================================================
 # Description   =  "This script is accepts 5 and returns everage number of 5 
 #                   
 # Name          =  "Serhiy Malyy"
 # Email         =  "ThisIsPublicGit@nobody.com"
 # ========================================================================
require 'optparse'
 # OptionParser is a class for command-line option analysis
OptionParser.new do |opts| # opts is var 
 # Option one 
	opts.on("-a", "--first_number") do
		$one = ARGV[0]  # <<- GLOBAL ($) 
		#puts $one
	end
 # Option two	
	opts.on("-b", "--second_number") do
		$two = ARGV[0]  # <<- GLOBAL ($) 
		#puts $two
	end
	 # Option three	
	opts.on("-c", "--third_number") do
		$three = ARGV[0]  # <<- GLOBAL ($) 
		#puts $three
	end
	 # Option four	
	opts.on("-d", "--fourth_number") do
		$four = ARGV[0]  # <<- GLOBAL ($) 
		#puts $four
	end
	# Option five	
	opts.on("-e", "--fifth_number") do
		$five = ARGV[0]  # <<- GLOBAL ($) 
		#puts $five
	end
	 
end.parse!

 # Format output string 	
 # Self note in order for everage_score to become float , all valuesmust be float
   everage_score = ( $one.to_f + $two.to_f + $three.to_f + $four.to_f + $five.to_f ) / 5.0
 
 # print out the results 
   puts "Average score of #{$one}, #{$two}, #{$three}, #{$four} and #{$five} is #{everage_score}"
