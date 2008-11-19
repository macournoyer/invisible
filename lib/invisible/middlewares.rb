module Invisible
  module Middlewares
    def before(&block)
      use Middleware::Before, &block
    end
    
    def layout(name)
      use Middleware::Layout, name
    end
  end
end