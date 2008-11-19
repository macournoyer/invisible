module Invisible
  module Middleware
    # Makes sure the body is always a String.
    class NormalizeBody
      def initialize(app)
        @app = app
      end
      
      def call(env)
        status, headers, body = @app.call(env)
        
        [status, headers, convert(body)]
      end
      
      def convert(body)
        case body
        when Rack::Response
          convert(body.body)
        when String
          body
        when Array
          body.join("/n")
        when nil
          ""
        else
          if body.respond_to?(:each)
            string = ""
            body.each { |chunk| string << chunk }
            string
          else
            body.to_s
          end
        end
      end
    end
  end
end