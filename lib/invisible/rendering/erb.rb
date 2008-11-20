require "erb"

module Invisible
  module Rendering
    module Erb
      extend self
      
      Template.register_engine self, :erb
      
      def render(string, context)
        ERB.new(string).result(context.send(:binding))
      end
    end
  end
end