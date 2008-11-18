require "forwardable"

module Invisible
  class Application
    extend Forwardable
    
    def_delegators :@resource, :call
    
    def initialize(&block)
      @resource = Context.create("/", &block)
    end
  end
end