 # ========================================================================
 # Script     =  script_22_02.rb
 # ========================================================================
 # Description   =  "The script in accepting path argument , reads through csv file 
 #                   and returns line data.
 # Name          =  "Serhiy Malyy"
 # Email         =  "ThisIsPublicGit@nobody.com"
 # ========================================================================
require 'optparse'
require 'json'
json_file = ""
 # OptionParser is a class for command-line option analysis
 OptionParser.new do |opts| # opts is var 
  # Option one 
	opts.on("-i", "--input") do
		$file_name = ARGV[0]  # <<- GLOBAL ($) VAR a
		 #puts ARGV[0]
	end 
 end.parse!
 
  json_file = File.read($file_name)
  #puts json_file #"Class Of JSON File.Read"
  element = JSON.parse(json_file)
	#puts element.values
	#puts element.class
  
  #if RUBY_PLATFORM =~ /darwin/ then
	   script_name = __FILE__.split("/").to_a.last
   # else
#for windows OS  assignemt was only supposed to be "script_name = __FILE__" but it returns partial path as well 
      #script_name = __FILE__.split("/").to_a.last
	   #puts script_name.class
	   #puts script_name	
  #end
 
 #return the output to command line . Note.chomp method = remove new line spaces 
 puts "My favorite fruit is : #{element[script_name]["fruits_a"].chop} or  #{element[script_name]["fruits_b"].chop}"

