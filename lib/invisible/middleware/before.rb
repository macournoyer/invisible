module Invisible
  module Middleware
    class Before < Base
      def initialize(app, &block)
        @app = app
        @block = block
      end
      
      def call(env)
        # TODO Doesn't work, invisible.context is set after app is called
        if context = env["invisible.context"]
          context.instance_eval(&@block)
        end
        
        @app.call(env)
      end
    end
  end
end