 # ========================================================================
 # Script     =  script_18_03.rb
 # ========================================================================
 # Description   =  "This script is accepting two integes using trollup 
 #                   dividesfirst val by second and retrurns result   
 # Name          =  "Serhiy Malyy"
 # Email         =  "ThisIsPublicGit@nobody.com"
 # ========================================================================
 require 'trollop'
  val1 = ""
  val2 = ""
  opts = Trollop::options do
 # expecting integer from option
    opt:first, "", :long=> "first_number", :short=> "-a", :type => :int      
 # expecting integer from option 
    opt:second, "",  :long=> "second_number" , :short=> "-b", :type => :int
	
  end
 # drop option to vars 
  val1 = opts[:first] 
  val2 = opts[:second]
  
 # Retru Values to the screen 
  puts "When I am dividing #{val1} by #{val2} I am always have #{val1 / val2} !"
  #p opts