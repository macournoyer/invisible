module Invisible
  module Action
    attr_reader :method, :request, :response, :params
    
    def initialize(method, &block)
      @method = method
      @block  = block
    end
    
    def call(env)
      @request  = Rack::Request.new(env)
      @response = Rack::Response.new
      @params   = @request.params
      
      instance_eval(&@block)
      
      @response.finish
    end
  end
end