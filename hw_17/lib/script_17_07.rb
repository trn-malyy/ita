 # ========================================================================
 # Script        =   script_17_07.rb
 # ========================================================================
 # Description   =  "This script is accepting arguments and trying to match First Last name pattern, 
 #                   script will returne mached First Last name to command line 
 # Name          =  "Serhiy Malyy"
 # Email         =  "ThisIsPublicGit@nobody.com"
 # ========================================================================

require 'optparse'
# First name last name reg EX
reg_ex = /[A-Z][a-z]+\s[A-Z][a-z]+/

options = {}
OptionParser.new do |opts|
  opts.banner = "--sentence Wednesday morning, John Smith was walking on the street."

  opts.on("--sentence", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end
end.parse!

 #p options
 #p ARGV
 #p ARGV.class
 # Place r=array to string and matcg reg ex
name = ARGV.join(" ").match reg_ex
# return output to command line with mached first last names 
puts "His name is : \"#{name}\""
