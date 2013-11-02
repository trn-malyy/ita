 # ========================================================================
 # Script     =  script_18_06.rb
 # ========================================================================
 # Description   =  "This script is accepts number of options using trollop
#                    and returns everage number provided option 
 # Name          =  "Serhiy Malyy"
 # Email         =  "ThisIsPublicGit@nobody.com"
 # ========================================================================
require 'trollop'
summary = 0
everage = 0
# Take all the options and put them to array 
opts = Trollop::options do
 opt :array, "The array of integers", :long=> "numbers", :type => :ints
end
 # Loop through all ints in array to get the sammary of all 
 opts[:array].each do |nums|
	summary = (summary + nums.to_i)
 end

 #convert number of ints to float 
 items = opts[:array].length.to_f
 # calculate the everage 
 everage = summary / items
 #return result 
 puts "The summary of the following numbers is: #{everage}"
	
# p opts
# puts opts[:array].class
# puts opts[:array].length
#summary = 
