module Invisible
  class Request < Rack::Request
    def self.env_attr_accessor(name, env_key="invisible.#{name}")
      define_method(name)       { env[env_key] }
      define_method("#{name}=") { |value| env[env_key] = value }
    end
    
    env_attr_accessor :context
    env_attr_accessor :pipeline
    env_attr_accessor :layout
  end
end