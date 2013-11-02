 # ========================================================================
 # Script     =  script_18_02.rb
 # ========================================================================
 # Description   =  "This script is accepting two options using trollup 
 #                   and returns them in command line   
 # Name          =  "Serhiy Malyy"
 # Email         =  "ThisIsPublicGit@nobody.com"
 # ========================================================================
 require 'trollop'
 
  opts = Trollop::options do
 # 
    opt:first, "", :long=> "first_fruit", :short=> "-a", :type => :string      
 #
    opt:second, "",  :long=> "second_fruit" , :short=> "-b", :type => :string
	
  end
  
 # Retru Values to the screen 
  puts "My favorite fruit is #{opts[:first].chop} or #{opts[:second].chop}"
  #p opts