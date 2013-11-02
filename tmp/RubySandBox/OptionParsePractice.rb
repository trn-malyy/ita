 # ========================================================================
 # Script     =  OptionPrarsePractice.rb
 # ========================================================================
 # Description   =  "This script is accepting to arguments from command line and puts it in to "
 #                   "and puts then in to sentence  
 # Name       =  "Serhiy Malyy"
 # Email     =  "ThisIsPublicGit@nobody.com"
 # ========================================================================
require 'optparse'
 
OptionParser.new do |opts|
  
	opts.on("-f", "--first") do
		$a = ARGV[0]
	
	end
	
	opts.on("-s", "--second") do
		$b = ARGV[0]
	 end
	 
end.parse!
   
   
	puts "Option One + Option Two = #{$a.to_i + $b.to_i}"
 #puts "My favorite fruits are #{apple}s and #{banana}s"
 #puts "My favorite fruits are #{arg01}s and #{arg02}s"