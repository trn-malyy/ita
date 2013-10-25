# ========================================================================
# Script 		=	script_13_05.rb
# ========================================================================
# Description 	=	'This script is acceting 5 numeric arguments and returns the everage number of 5 
# Name 			=	"Serhiy Malyy"
# Email 		=	"ThisIsPublicGit@nobody.com"
# ========================================================================
# var declarations 
a = ARGV[0]
b = ARGV[1]
c = ARGV[2]
d = ARGV[3]
e = ARGV[4]
# sum up the evarage scrore
average_score = (a.to_f + b.to_f + c.to_f + d.to_f + e.to_f)/5
# return the everage score to command line 
puts "Output: Average Score of (#{a},#{b},#{c},#{d},and #{e}) is #{average_score}"
