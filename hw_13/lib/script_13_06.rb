# ========================================================================
# Script 		=	script_13_06.rb
# ========================================================================
# Description 	=	'This script is accepting arguments in form of integer from command line 
#					 and calculated the everage number of all 
# Name 			=	"Serhiy Malyy"
# Email 		=	"ThisIsPublicGit@nobody.com"
# ========================================================================
# declare empty strings  
sum_of_args = 0
next_arg_val = ""
num_of_args = []
sum = ""
#commented statements = playing with array methods
#puts ARGV.class << Testing is Array? 
#puts ARGV.inspect << Testing has items values? 
# garb the number of itmes inside of array and put it in the var 
num_of_args = ARGV.length 
#puts  num_of_args <<Testing number of items ?

#loop through each item insed of array and add them togeather 
ARGV.each do|next_arg_val|
  sum_of_args = next_arg_val.to_f + sum_of_args
end 
#calculate summary 
sum = sum_of_args/num_of_args
# return summary to command line 
puts "Output: The summary of the following numbers #{ARGV.join(",")} is #{sum}"
