require 'json'

class TestSpec
  attr_accessor :test_spec

  def initialize(test_spec_path)
    @test_spec = read_spec(test_spec_path)
    @test_spec
  end

  def read_spec(spec_path)
    spec = File.open(spec_path) { |spec_file| JSON.parse(spec_file.read) }
    spec
  end

  def valid_spec?(test_spec = @test_spec)
    true
  end

end