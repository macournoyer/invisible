require "haml"

module Invisible
  module Rendering
    module Haml
      extend self
      
      Template.register_engine self, :haml
      
      def render(string, context)
        Haml::Engine.new(string).render(context)
      end
    end
  end
end