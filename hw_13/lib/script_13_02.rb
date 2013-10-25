# ========================================================================
# Script 		=	script_13_02.rb
# ========================================================================
# Description 	=	'This script is accepting to arguments from command line and puts it in to 
#                    and puts then in to sentence where last chars in string are removed'
# Name 			=	"Serhiy Malyy"
# Email 		=	"ThisIsPublicGit@nobody.com"
# ========================================================================

arg01 = ARGV[0]
arg02 = ARGV[1]

puts "My favorite fruit is #{arg01.chop} or #{arg02.chop}"
