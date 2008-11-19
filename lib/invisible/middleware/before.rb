module Invisible
  module Middleware
    class Before
      def initialize(app, &block)
        @app   = app
        @block = block
      end
      
      def call(env)
        request = Request.new(env)
        
        request.context.instance_eval(&@block) if request.context
        
        @app.call(env)
      end
    end
  end
end