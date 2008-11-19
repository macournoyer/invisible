module Invisible
  # Middleware pipeline. Used to chain middlewares to any app instance.
  # NOT threadsafe! Because of <tt>Tail#app</tt>.
  class Pipeline
    class Tail
      attr_accessor :app
      
      def call(env)
        @app.call(env)
      end
    end
    
    def initialize
      @app = @tail = Tail.new
    end
    
    def apply(app)
      @tail.app = app
      self
    end
    
    def call(env)
      env["invisible.context"] = @tail.app
      @app.call(env)
    end
    
    def use(middleware, *args, &block)
      @app = middleware.new(@app, *args, &block)
    end
  end
end