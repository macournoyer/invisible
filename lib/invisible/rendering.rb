module Invisible
  module Rendering
    def render(*args, &block)
      options = args.last.is_a?(Hash) ? args.pop : {}
      request.render_options = options
      response.body = args.first
    end
  end
end