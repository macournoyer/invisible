module Invisible
  module Rendering
    def render(content, options={})
      options[:layout] = request.layout if options[:layout].nil?
      
      # TODO
      # if options[:layout]
      
      response.status = options[:status] || 200
      response.body   = content
    end
  end
end