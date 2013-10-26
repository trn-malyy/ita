# ========================================================================
# Script 		=	script_15_01.rb
# ========================================================================
# Description 	=	"This scrip designed to return your machines subnet mask. 
#                    Script accepts only one argument [subnet_mask].
# Name 			=	"Serhiy Malyy"
# Email 		=	"PublicRepo@nobody.com"
# ========================================================================
# Declare Regular Expressions 
comm_line_arg = ARGV[0]
reg_ex_mac = /[^(?:0x)]?([\da-fA-F]{8})/
re_ex_pc = /\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/
# If command line argument is requesting to display subnet mask (subnet_mask)
if ARGV[0] == 'subnet_mask' then

# Depending on your OS run ipconfig command and cpature text to file ip.txt
 if RUBY_PLATFORM =~ /32/ then  
# If Windows run ipconfig /all and store to ip.txt
   %x'ipconfig /all > ip.txt'  #Self Note: file ip.txt is save in the same directory when script was executed
   # place captured text from ip.txt file to string called 'file'
   file = File.read('ip.txt')
#  Using .scan method with RegEx returned array of matched values instead of MatchData   
   match = file.scan re_ex_pc
   # puts match.class  << 
# Assign second value in array to subnet_mask var. the first match is IPv$ address  
   subnet_mask = match[1] 
   puts "Subnet mask: #{subnet_mask}"
 else
# Unix family OS run ifconfig command  
   %x'ifconfig > ip.txt'
   # place captured text from ip.txt file to string called 'file'
   file = File.read('ip.txt')
#  Using .scan method with RegEx returned array of matched values instead of MatchData   
   match = file.scan reg_ex_mac
#  gsub returns a copy of str with the all occurrences of pattern substituted for the second argument.
   subnet_mask = match[1].to_s.gsub(/\[/,"").gsub(/"/,"").gsub(/\]/,"")
#  print out converted hexadecimal subnet mask outside of my current ruby understanding   
   puts "subnet mask : #{subnet_mask.scan(/../).map{|i|i.to_i(16)}.join(".")}"
 end 

else 
# Notify to enter correct argument
 puts "Unkown argument. Script designed to display subnet mask only." 
 
end 
# Self note: Data conversion error will occur if match is not converted to string. Match is MatchData object, not string.
