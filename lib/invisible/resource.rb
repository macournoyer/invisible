module Invisible
  class Resource
    attr_reader :method, :request, :response, :params
    
    def initialize(method, &block)
      @method = method
      @block  = block
    end
    
    def call(env)
      @request  = Rack::Request.new(env)
      @response = Rack::Response.new
      @params   = @request.params
      
      instance_eval(&@block)
      
      @response.finish
    end
    
    class << self
      attr_accessor :uri, :methods, :resources
      
      def uri;       @uri       ||= "/" end
      def methods;   @methods   ||= {}  end
      def resources; @resources ||= []  end
      
      def get(uri=nil, &block)
        klass = uri ? resource(uri) : self
        klass.methods["GET"] = klass.new("GET", &block)
      end
      
      def resource(uri="/", &block)
        resource_name = classify(uri)
        uri           = normalize_uri(self.uri + "/" + uri)
        
        resource = subclass(resource_name) do
          @uri = uri
          module_eval(&block) if block
        end
        
        resources << resource
        resources.sort! { |x,y| x.uri <=> y.uri }.reverse!
        
        resource
      end
      
      def call(env)
        request = Rack::Request.new(env)
        
        if uri == request.path_info && method = methods[request.request_method] # TODO match
          response = method.call(env)
        elsif resource = resources.detect { |resource| request.path_info.index(resource.uri) }
          response = resource.call(env)
        end
        response || Rack::Response.new("Not found", 404).finish
      end
      
      private
        def normalize_uri(uri)
          "/" + uri.squeeze("/").gsub(/^\//, "")
        end
        
        def classify(uri)
          uri.
            squeeze("/").
            gsub(/^\//, "").
            gsub(":", "").
            gsub("-", "_").
            gsub(/\/(.?)/) { "_#{$1.upcase}" }.
            gsub(/(?:^|_)(.)/) { $1.upcase }.
            gsub(/^$/, "Root")
        end
    end
  end
end