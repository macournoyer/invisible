module Invisible
  module Action
    include Rendering
    
    attr_reader :method, :request, :response, :params
    
    def initialize(method, &block)
      @method = method
      @block  = block
    end
    
    def call(env)
      @request  = Request.new(env)
      @response = Response.new
      @params   = @request.params
      
      instance_eval(&@block)
      
      @response.finish
    end
  end
end