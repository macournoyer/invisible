module Invisible
  module Rendering
    def render(*args, &block)
      options = args.last.is_a?(Hash) ? args.pop : {}
      content = args.first
      
      # Extract options
      @response.status = options.delete(:status) || 200
      
      # Set headers
      @response.headers.merge!(options)
      @response.headers["Content-Length"] ||= content.size.to_s
      @response.headers["Last-Modified"]  ||= Time.now.httpdate
      
      @response.body = content
    end
  end
end