require_relative "spec_file"

class EnvCredentialsSpec < SpecFile
  attr_accessor :env_credentials_spec,:spec

  def initialize(env_credentials_spec_path)
    @spec = super(env_credentials_spec_path)
    @env_credentials_spec = @spec
  end

end