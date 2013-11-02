#require 'ap'
require 'optparse'
$aaa = []
$zzz = []
options = {}
OptionParser.new do |opts|

  opts.on("-b", "--brands bName1,bName2,bNameN", Array, "Check specific brands by name") do |b|
    options[:brands] = $aaa
	
	
  end

  opts.on("-l", "--large lSku1,lSku2,lSkuN", Array, "Large SKUs - List CSVs") do |l|
    options[:large_skus] = l
  end

  opts.on("-s", "--small wQueue1,wQueue2,wQueue3, wQueue4", Array, "Small SKUs - List CSVs") do |s|
    options[:small_skus] = $zzz
	puts s.to_s
  end
	puts &zzz.to_s
	puts &aaa.to_s
end.parse!(ARGV)

# ap options