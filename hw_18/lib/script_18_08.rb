 # ========================================================================
 # Script     =  script_18_08.rb
 # ========================================================================
 # Description   =  "Scripts accepts 4 options using trollop sorts them and returns sorted results  
 # Name          =  "Serhiy Malyy"
 # Email         =  "ThisIsPublicGit@nobody.com"
 # ========================================================================
 require 'trollop'
 season_val =[]
 
opts = Trollop.options do 
  opt :first, '', :long=> "first_season", type: :string 
  opt :second, '', :long=> "second_season", type: :string   
  opt :third, '', :long=> "third_season", type: :string   
  opt :fourth, '', :long=> "fourth_season", type: :string   
end
 # very silly way of doing it but it works 
 # Convert hash to array 
 season_val = opts.values.to_a
 # Take only first 4 itmes from array and sort them
 season_val = season_val[0..3].sort 
 #print out the result 
 puts "Here are sorted (alphabetically) words: #{season_val.join(" ")}"






