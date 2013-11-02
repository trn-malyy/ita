 # ========================================================================
 # Script     =  script_18_01.rb
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
  puts "My favorite fruits are: #{opts[:first]}s and #{opts[:second]}s"
  #p opts