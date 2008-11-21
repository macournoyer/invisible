module Invisible
  class Request < Rack::Request
    def self.env_attr_accessor(name, env_key="invisible.#{name}")
      define_method(name)       { env[env_key] }
      define_method("#{name}=") { |value| env[env_key] = value }
    end
    
    env_attr_accessor :context
    env_attr_accessor :pipeline
    env_attr_accessor :layout
    env_attr_accessor :path_params
    env_attr_accessor :rendered
    
    def format
      File.extname(path_info)[1..-1] || "html"
    end
    
    def resource
      context.class
    end
  end
end