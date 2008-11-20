module Invisible
  module Middleware
    class Layout
      def initialize(app, name)
        @app  = app
        @name = name
      end
      
      def call(env)
        env["invisible.layout"] = @name
        @app.call(env)
      end
    end
  end
end