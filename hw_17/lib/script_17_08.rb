 # ========================================================================
 # Script        =   script_17_08.rb
 # ========================================================================
 # Description   =  "This script is accepting frou seasons and in form of options 
 #					 and returnes them sorted alphabetically
 # Name          =  "Serhiy Malyy"
 # Email         =  "ThisIsPublicGit@nobody.com"
 # ========================================================================
require 'optparse'

 # OptionParser is a class for command-line option analysis
OptionParser.new do |opts| # opts is var 
 # Option one 
	opts.on("-a", "-b", "-c", "-d") do	
	end
	# Option two 
	opts.on("--second_season", "--third_season", "--fourth_season", "--first_season") do	
	end
end.parse!
  # Return Sorted Seasons 
  puts "Here are sorted (alphabetically) words: #{ARGV.sort.join(" ")}"