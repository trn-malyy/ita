
my_arg = ARGV[0]

re1 = /\b([0-9a-fA-F]{2}(\-\|\:)){5}[0-9a-fA-F]{2}\b/
re2 = /\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/
re3 = /[\dA-Fa-f]{1,4}(:[\dA-Fa-f]{1,4})*::([\dA-Fa-f]{1,4}(:[\dA-Fa-f]{1,4})*)?%\d{2}/
#re4 = /\b\w+\b/

check = my_arg.match re4
puts check 
puts check.class

puts my_arg
puts my_arg.class

puts ' going to if ' 
if check.class == MatchData then
  puts "Your IPv4 address of your computer is : #{my_arg}"
end 
puts ' done with if '





#puts '------------------------'
#puts my_arg
#puts ARGV[0]
#puts '------------------------'
#puts my_arg.class
#puts re1.class
#puts '------------------------'
#check = my_arg.match re2
#puts check.class
#puts check

#check = ARGV[0].match re1
puts '------------------------'
#puts check



#line = "This is a line";
#3if ( line =~ /line/ )
#puts "String line is there"
#else
#puts "String line is NOT there"
#end
#String

#if (my_arg )