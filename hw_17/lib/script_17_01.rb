 # ========================================================================
 # Script     =  script_17_01.rb
 # ========================================================================
 # Description   =  "This script is accepting two options using Option Praser 
 #                   and returns them in command line   
 # Name          =  "Serhiy Malyy"
 # Email         =  "ThisIsPublicGit@nobody.com"
 # ========================================================================
require 'optparse'
 # OptionParser is a class for command-line option analysis
OptionParser.new do |opts| # opts is var 
  # Option one 
	opts.on("-f", "--first_fruit") do
		$a = ARGV[0]  # <<- GLOBAL ($) VAR a
	end
   # Option two	
	opts.on("-s", "--second_fruit") do
		$b = ARGV[0]  # <<- GLOBAL ($) VAR b
	end
	 
end.parse!
# Slef Note : Returning the out put pay attention to dollar sign $ infront of vars .
# We're accesing the global string inside of code block so we have to point out to global
 puts "My favorite fruits are: #{$a.to_s}s and #{$b.to_s}s"
