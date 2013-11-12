require 'json'

class SpecFile

  attr_accessor :spec

  def initialize(spec_path)
    @spec = Hash.new
    @spec = read_spec(spec_path)
    @spec
  end

  def read_spec(spec_path)
    raw_spec = ""
		raw_spec = File.open(spec_path) {|f| f.read.encode('UTF-8') }
		raw_spec.gsub!( "\u2229\u2557\u2510","")
    #add other
		spec = JSON.parse(raw_spec)
    spec
  end

end
