# ========================================================================
# Script 		=	script_13_04.rb
# ========================================================================
# Description 	=	'This script is accepting arguments in form of integer from command line 
#					 each argument placed in the string and formatted to appear as an IP address 
# Name 			=	"Serhiy Malyy"
# Email 		=	"ThisIsPublicGit@nobody.com"
# ========================================================================
# declare empty strings  
ip = ""
next_arg_val = ""
# Spin collection of command line arguments in a do loop 
# For each argument in collection assing its value to var next_arg_val  
ARGV.each do|next_arg_val|
ip = (ip + next_arg_val + ".")
#ip + = next_arg_val <<Self note: this did not work for me because I used space between + and = ! 
end 
# remove the last "." from ip var
ip = ip.chop
# return formated value to command line 
puts "My IP adress is #{ip}"



