 # ========================================================================
 # Script        =   script_17_03.rb
 # ========================================================================
 # Description   =  "This script is accepting two options using Option Praser 
 #                   divides the first by second and returns the result to command line
 # Name          =  "Serhiy Malyy"
 # Email         =  "ThisIsPublicGit@nobody.com"
 # ========================================================================
require 'optparse'
 # OptionParser is a class for command-line option analysis
OptionParser.new do |opts| # opts is var 
 # Option one 
	opts.on("-f", "--first_number") do
		$a = ARGV[0]  # <<- GLOBAL ($) VAR a
		# puts $a
	end
 # Option two	
	opts.on("-s", "--second_number") do
		$b = ARGV[0]  # <<- GLOBAL ($) VAR b
		# puts $b
	end
	 
end.parse!
 # Math operation to results var	
	result =($a.to_i / $b.to_i)

 # Slef Note : Returning the out put pay attention to dollar sign $ infront of vars .
 # We're accesing the global string inside of code block so we have to point out to global
 puts "When I am dividing #{$a.to_i} by #{$b.to_i} I am always have #{result} "
