module Invisible
  class Resource
    attr_reader :resources
    
    def initialize(app, route=nil, &implementation)
      @app       = app
      @route     = nil
      @resources = []
      instance_eval(&block)
    end
    
    def get(route, &block)
      @resources << Action.new(self, "GET", route, &block)
    end
    
    def resource(route, &block)
      @resources << Resource.new(@app, route, &block)
    end
    
    def call(env)
      response = nil
      resources.detect { |resource| response = resource.call(env) }
      response || Rack::Response.new("Not found", 404).finish
    end
  end
end