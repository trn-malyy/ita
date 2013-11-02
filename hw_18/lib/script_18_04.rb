 # ========================================================================
 # Script     =  script_18_04.rb
 # ========================================================================
 # Description   =  "This script is accepting 4 options using trollup 
 #                   and returns them in form of Ipv4 address   
 # Name          =  "Serhiy Malyy"
 # Email         =  "ThisIsPublicGit@nobody.com"
 # ========================================================================
 require 'trollop'
  val1 = ""
  val2 = ""
  opts = Trollop::options do
 # expecting integer from option
    opt:first, "", :long=> "first_octet", :short=> "-a", :type => :string      
 # expecting integer from option 
    opt:second, "",  :long=> "second_octet" , :short=> "-b", :type => :string
 # expecting integer from option
    opt:third, "", :long=> "third_octet", :short=> "-c", :type => :string      
 # expecting integer from option 
    opt:fourth, "",  :long=> "fourth_octet" , :short=> "-d", :type => :string	
  end
  
 # Retru Values to the screen 
  puts "My IP Address is #{opts[:first]}.#{opts[:second]}.#{opts[:third]}.#{opts[:fourth]}"
  