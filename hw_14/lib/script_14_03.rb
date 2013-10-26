# ========================================================================
# Script 		=	script_14_03.rb
# ========================================================================
# Description 	=	"This scrip will return your machine IP address or MAC address. Script accepts 1 0f 4 arguments :
#                   [ipv4_address] for IPv4 , [reg_ex_mac] for MAC, [ipv6_address] for IPv6, and other...
# Name 			=	"Serhiy Malyy"
# Email 		=	"PublicRepo@nobody.com"
# ========================================================================
# Assign command argument to string 
reply = ""
my_arg = ARGV[0]

# Declare Regular Expressions 
reg_ex_mac = /\b([0-9a-fA-F]{2}(\-\|\:)){5}[0-9a-fA-F]{2}\b/
re_ex_ipv4 = /\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/
re_ex_ipv6 = /[\dA-Fa-f]{1,4}(:[\dA-Fa-f]{1,4})*::([\dA-Fa-f]{1,4}(:[\dA-Fa-f]{1,4})*)?%\d{2}/
reg_ex_word = /\b\w+\b/

# Depending on your OS run ipconfig command and cpature text to file ip.txt
if RUBY_PLATFORM =~ /32/ then  
# If Windows run ipconfig /all and store to ip.txt
   %x'ipconfig /all > ip.txt'  #Self Note: file ip.txt is save in the same directory when script was executed
else
# Unix family OS run ifconfig command  
   %x'ifconfig > ip.txt'
end 

# place captured text from ip.txt file to string called 'file'
file = File.read('ip.txt')

# Select desired Regular Expression based on argument provided and run text match from file string   
case my_arg  # <<Self note: Just like VB languages, ruby does not require(break;) to prevent fall thorough select case
 when 'ipv4_address'
   match = file.match re_ex_ipv4
   reply = "IPv4 address of your computer: "
 when 'mac_address'
   match = file.match reg_ex_mac
   reply = "Mac address of your computer:  "
 when 'ipv6_address'
  match = file.match re_ex_ipv6
  reply = "IPv6 address of your computer: "
else 
  match = file.match reg_ex_word
  reply = "Match result: "
end

# Construct return sentence and print out result to command line
puts reply + match.to_s  

# Self note: Data conversion error will occur if match is not converted to string. Match is MatchData object, not string.
