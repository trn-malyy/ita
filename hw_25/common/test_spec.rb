require 'json'

# This class is used to read the test specs in JSON format
class TestSpec
  attr_accessor :test_spec

  def initialize(test_spec_path)
    @test_spec = read_spec(test_spec_path)
    @test_spec
  end

  def read_spec(spec_path)
    raw_spec = ""
    raw_spec = File.open(spec_path) {|f| f.read.encode('UTF-8') }
    raw_spec.gsub!( "\u2229\u2557\u2510","")
    spec = JSON.parse(raw_spec)
    spec
  end

  def valid_spec?(test_spec = @test_spec)
    true
  end
end