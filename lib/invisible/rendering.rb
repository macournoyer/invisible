module Invisible
  module Rendering
    def render(*args, &block)
      options = args.last.is_a?(Hash) ? args.pop : {}
      content = args.first
      
      # Extract options
      @response.status = options.delete(:status) || 200
      @response.headers.merge!(options)
      # @response.headers["Last-Modified"]  ||= Time.now.httpdate
      
      @response.body = content
    end
  end
end