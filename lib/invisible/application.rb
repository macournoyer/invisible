require "forwardable"

module Invisible
  class Application
    extend Forwardable
    
    def_delegators :@resource, :call
    
    def initialize(&block)
      @resource = Resource.new(self, &block)
    end
  end
end