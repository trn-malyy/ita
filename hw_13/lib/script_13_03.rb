# ========================================================================
# Script 		=	script_13_03.rb
# ========================================================================
# Description 	=	'This script is accepting two numeric arguments from command and perfoms division
#					 of first arg by second, the result of division is returned back to command line'
# Name 			=	"Serhiy Malyy"
# Email 		=	"ThisIsPublicGit@nobody.com"
# ========================================================================
# collect command line arguments to variables and covert the m to integer 
arg01 = ARGV[0].to_i
arg02 = ARGV[1].to_i

# divide variables and assign result to var summ
summ = arg01 / arg02

# return division result to command line 
puts "When I am dividing  #{arg01} by #{arg02} I am always have #{summ}!"

