# ========================================================================
# Script 		=	script_13_07.rb
# ========================================================================
# Description 	=	'This script is accepting arguments and trying to match First Last name pattern, 
#                    script will returne mached First Last name to command line 
# Name 			=	"Serhiy Malyy"
# Email 		=	"ThisIsPublicGit@nobody.com"
# ========================================================================
# Create RegEx to match First Last name patern 
reg_ex = /[A-Z][a-z]+\s[A-Z][a-z]+/
# take command line ags and join them in a single array match reg ex and assign to name var 
name = ARGV.join(" ").match reg_ex
# return output to command line with mached first last names 
puts "Output: His name is : \"#{name}\""
