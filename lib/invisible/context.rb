module Invisible
  class Context
    include Action
    include Rendering
    
    extend Resource
    extend Routing
    extend Middlewares
  end
end