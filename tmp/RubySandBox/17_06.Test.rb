 # ========================================================================
 # Script        =   script_17_05.rb
 # ========================================================================
 # Description   =  "This script is accepts 5 and returns everage number of 5 
 #                   
 # Name          =  "Serhiy Malyy"
 # Email         =  "ThisIsPublicGit@nobody.com"
 # ========================================================================
require 'optparse'
$my_array = []
$cr_option = ''
$arg_sum = 0
 # OptionParser is a class for command-line option analysis
OptionParser.new do |opts| # opts is var 
 # Option one 
	opts.on("-a", "--first_ number", "-b", "--second_ number", "-c", "--third_ number", "-d", "--fourth_ number", "-e", "--fifth_ number", "-f", "--sixth_ number") do	
		$my_array << ARGV[0]	
	end
end.parse!
	
	puts $my_array.length
	puts "   "
	$my_array.each do |z|
		puts z
		$arg_sum = (z.to_f + $arg_sum.to_f)
	 end
	 puts "   "
	 puts $arg_sum 
 # Format output string 	
 # Self note in order for everage_score to become float , all valuesmust be float
 #  everage_score = ( $one.to_f + $two.to_f + $three.to_f + $four.to_f + $five.to_f ) / 5.0
 
 # print out the results 
 #  puts "Average score of #{$one}, #{$two}, #{$three}, #{$four} and #{$five} is #{everage_score}"

   