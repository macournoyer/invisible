require "invisible/action"
require "invisible/resource"

module Invisible
  class Context
    include Action
    extend Resource
  end
end