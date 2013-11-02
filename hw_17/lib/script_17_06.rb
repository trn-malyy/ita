 # ========================================================================
 # Script        =   script_17_05.rb
 # ========================================================================
 # Description   =  "This script is accepts 5 and returns everage number provided option 
 #                   
 # Name          =  "Serhiy Malyy"
 # Email         =  "ThisIsPublicGit@nobody.com"
 # ========================================================================
require 'optparse'
 #$short_array = []
 #$long_array = [] 
$my_aray = []
$arg_sum = 0
 # OptionParser is a class for command-line option analysis
OptionParser.new do |opts| # opts is var 
 # Option one 
	opts.on("-a", "-b", "-c", "-d", "-e", "-f", "-g", "-h", "-i", "-j") do	
		$my_aray << ARGV[0]
		#$short_array << ARGV[0]	
		#puts " Test Call I hit first option short "
	end
	# Option two 
	opts.on("--first_number","--second_number","--third_number","--fourth_number","--fifth_number","--sixth_number") do	
		$my_aray << ARGV[0]
		#$long_array << ARGV[0]
		#puts "Test Call I hit second option long"
	end
end.parse!
 # Testing options , do not remove commented code
	#puts $long_array.length
	#puts $short_array.length
	#puts "   "
 # No need for the whole if block when using same array name in options	
	# if $long_array.length == 0 then
	#  $my_aray = $short_array 
	#  else
	#    $my_aray = $long_array 
	# end
  # spin array to calculate the summary of all option	 
	$my_aray.each do |z|
	    #puts z
		$arg_sum = (z.to_f + $arg_sum.to_f)
	 end
 # Get the number of options 
	 num = $my_aray.length
 # calculate the everage number 
	 everage = $arg_sum/num
	 #puts everage.class
 # print out the results 
  puts "The everage of the following numbers is: #{$my_aray.join(", ")} is #{everage}"

   