module Invisible
  # Middleware pipeline. Used to chain middlewares to any app instance.
  class Pipeline
    extend Forwardable
    
    class MiddlewareDesciptor < Struct.new(:klass, :args, :block)
      def apply(app)
        klass.new(app, *args, &block)
      end
    end
    
    attr_reader :middlewares
    
    def_delegators :@middlewares, :size
    
    def initialize(middlewares=[])
      @middlewares = middlewares
    end
    
    def apply(app)
      @middlewares.reverse.each { |middleware| app = middleware.apply(app) }
      app
    end
    
    def merge(pipeline)
      Pipeline.new(pipeline.middlewares + @middlewares)
    end
    
    def use(middleware, *args, &block)
      @middlewares << MiddlewareDesciptor.new(middleware, args, block)
    end
  end
end