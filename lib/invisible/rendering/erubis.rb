require "erubis"

module Invisible
  module Rendering
    module Erubis
      extend self
      
      Template.register_engine self, :erb
      
      def render(string, context)
        Erubis::Eruby.new(string).result(context.send(:binding))
      end
    end
  end
end