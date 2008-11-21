module Invisible
  module Rendering
    def render(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      content = args.first
      
      # TODO init somewhere else
      template_locator = Template::Locator.new([File.dirname(__FILE__) + "/../../spec/fixtures/views"])
      
      case content
      when String, Array
        body = content
      when :nothing
        body = []
      else
        # Default to using the path of the current resource as the name of the template
        options[:template] = request.resource.route.to_filename unless options[:template]
        
        template = template_locator.locate(options[:template], request.format)
        body     = template.render(self)
      end
      
      # TODO render layout
      # options[:layout] = request.layout if options[:layout].nil?
      # if options[:layout]
      
      request.rendered = true
      
      response.status = options[:status] || 200
      response.body = body
    end
  end
end