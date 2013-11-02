 # ========================================================================
 # Script        =   script_17_04.rb
 # ========================================================================
 # Description   =  "This script is accepts 4 options using Option Praser 
 #                   formats them to appear like IPv4 address and returns to command prompt
 # Name          =  "Serhiy Malyy"
 # Email         =  "ThisIsPublicGit@nobody.com"
 # ========================================================================
require 'optparse'
 # OptionParser is a class for command-line option analysis
OptionParser.new do |opts| # opts is var 
 # Option one 
	opts.on("-a", "--first_octet") do
		$a = ARGV[0]  # <<- GLOBAL ($) VAR a
		#puts $a
	end
 # Option two	
	opts.on("-b", "--second_octet") do
		$b = ARGV[0]  # <<- GLOBAL ($) VAR b
		#puts $b
	end
	 # Option three	
	opts.on("-c", "--third_octet") do
		$c = ARGV[0]  # <<- GLOBAL ($) VAR b
		#puts $b
	end
	 # Option four	
	opts.on("-d", "--fourth_octet") do
		$d = ARGV[0]  # <<- GLOBAL ($) VAR b
		#puts $b
	end
	 
end.parse!
 # Format output string 	
 # Slef Note : Returning the out put pay attention to dollar sign $ infront of vars .
 # We're accesing the global string inside of code block so we have to point out to global
	format_result = $a.to_s + '.'+ $b.to_s + '.'+ $c.to_s + '.'+ $d.to_s 
 # print out the results 
 puts "My IP Address is: #{format_result}"
