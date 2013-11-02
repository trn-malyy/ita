# ========================================================================
# Script 		=	script_16_01.rb
# ========================================================================
# Description 	=	"Script will scan home directory and will return to command line
#                    the number of files found in it
# Name 			=	"Serhiy Malyy"
# Email 		=	"PublicRepo@nobody.com"
# ========================================================================
# Declare Regular Expressions 
 regex_files_all = /(\w+\.\w{2,3})/
# regex_files_txt = /(\w+\.(txt))/
 list=[]

# Depending on your OS run ipconfig command and cpature text to file ip.txt
 if RUBY_PLATFORM =~ /32/ then  
# If Windows run dir/s and store to ip.txt
   %x'dir/s cd %HOMEDRIVE% %HOMEPATH% > list.txt'  #Self Note: file ip.txt is save in the same directory when script was executed
   sleep(10)
   # place captured text from ip.txt file to string called 'file'
   file = File.read('list.txt')

   #  Using .scan method with RegEx returned array of matched values instead of MatchData   
   file.scan(regex_files_all) do |all_match|
   list<<all_match
   end

   #  Self Note Array.size is similat to Ubound(Array), it returns integer. 
   puts "Your home directory contains: #{list.size} files"

 else
# Unix family OS run ifconfig command  
   %x'cd $HOME; ls -la > list.txt'
   # place captured text list.txt'file to string called 'file'
   sleep(10)
   # place captured text from list.txt' file to string called 'file'
   file = File.read('list.txt')

   #  Using .scan method with RegEx returned array of matched values instead of MatchData   
   file.scan(regex_files_all) do |all_match|
   list << all_match
   end
   
   puts "Your home directory contains: #{list.size} files"
end 
