module Invisible
  module Middleware
    class Before
      def initialize(app, &block)
        @app   = app
        @block = block
      end
      
      def call(env)
        if context = env["invisible.context"]
          context.instance_eval(&@block)
        end
        
        @app.call(env)
      end
    end
  end
end