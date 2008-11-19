module Invisible
  module Middleware
    class Layout
      def initialize(app, name)
        @app  = app
        @name = name
      end
      
      def call(env)
        status, headers, body = @app.call(env)
        
        # Only one layout can be applied
        if !env.has_key?("invisible.layout") && env.has_key?("invisible.context")
          context = env["invisible.context"]
          body = context.render("[#{body}]")
          env["invisible.layout"] = true
        end
        
        [status, headers, body]
      end
    end
  end
end