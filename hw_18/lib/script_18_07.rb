# ========================================================================
 # Script     =  script_18_07.rb
 # ========================================================================
 # Description   =  "Scripts accepts 5 number using trollup command line options 
 #                   calculated the everage of 5 and retruns them to command line  
 # Name          =  "Serhiy Malyy"
 # Email         =  "ThisIsPublicGit@nobody.com"
 # ========================================================================
 require 'trollop'
 reg_ex = /[A-Z][a-z]+\s[A-Z][a-z]+/
 
opts = Trollop.options do 
  opt :array, 'an array', :long=> "--sentence", type: :strings   
end
first_last_name = opts[:array].join(" ").match reg_ex
puts "His name is #{first_last_name}"

# puts "array: #{opts[:array].to_s}"
# puts "val: #{opts[:val].inspect}"