 # ========================================================================
 # Script     =  script_18_05.rb
 # ========================================================================
 # Description   =  "Scripts accepts 5 number using trollup command line options 
 #                   calculated the everage of 5 and retruns them to command line  
 # Name          =  "Serhiy Malyy"
 # Email         =  "ThisIsPublicGit@nobody.com"
 # ========================================================================
 require 'trollop'
 
  opts = Trollop::options do
 # expecting integer from option
    opt:first, "", :long=> "first_number", :short=> "-a", :type => :float      
 # expecting integer from option 
    opt:second, "",  :long=> "second_number" , :short=> "-b", :type => :float
 # expecting integer from option
    opt:third, "", :long=> "third_number", :short=> "-c", :type => :float     
# expecting integer from option 
    opt:fourth, "",  :long=> "fourth_number" , :short=> "-d", :type => :float		
 # expecting integer from option 
    opt:fifth, "",  :long=> "fifth_number" , :short=> "-e", :type => :float	
  end
 # calculate everage 
  everage_score = (opts[:first] + opts[:second] + opts[:third] + opts[:fourth] + opts[:fifth])/5.0
 # Retru Values to the screen 
  puts "Average score of  #{opts[:first].to_i},#{opts[:second].to_i},#{opts[:third].to_i},#{opts[:fourth].to_i} and #{opts[:fifth].to_i} is #{everage_score}"
 