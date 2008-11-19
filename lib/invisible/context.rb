module Invisible
  class Context
    include Action
    
    extend Resource
    extend Middlewares
  end
end