module Invisible
  module Middleware
    class ContentLength < Base
      def call(env)
        status, headers, body = @app.call(env)

        header = 'Content-Length'.freeze
        headers[header] = TypeAgnosticBody.new(body).size.to_s unless headers.has_key?(header)

        [status, headers, body]
      end
    end
    
  end
end