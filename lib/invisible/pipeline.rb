module Invisible
  # Middleware pipeline. Used to chain middlewares to any app instance.
  class Pipeline
    attr_reader :middlewares
    
    def initialize(middlewares=[])
      @middlewares = middlewares
    end
    
    def apply(app)
      @middlewares.reverse.each do |middleware, args, block|
        app = middleware.new(app, *args, &block)
      end
      app
    end
    
    def merge(pipeline)
      Pipeline.new(pipeline.middlewares + @middlewares)
    end
    
    def use(middleware, *args, &block)
      @middlewares << [middleware, args, block]
    end
  end
end