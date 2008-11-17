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
      attr_accessor :path, :methods, :resources
      
      def path;      @path      ||= "/" end
      def methods;   @methods   ||= {}  end
      def resources; @resources ||= []  end
      
      def get(path=nil, &block)
        klass = path ? resource(path) : self
        klass.methods["GET"] = klass.new("GET", &block)
      end
      
      def resource(path="/", &block)
        resource_name = classify(path)
        path          = normalize_path(self.path + "/" + path)
        
        resource = subclass(resource_name) do
          @path = path
          module_eval(&block) if block
        end
        
        resources << resource
        resources.sort! { |x,y| x.path <=> y.path }.reverse!
        
        resource
      end
      
      def call(env)
        request = Rack::Request.new(env)
        
        if self.path == request.path_info && method = methods[request.request_method] # TODO match
          response = method.call(env)
        elsif resource = resources.detect { |resource| request.path_info.index(resource.path) }
          response = resource.call(env)
        end
        response || Rack::Response.new("Not found", 404).finish
      end
      
      private
        def normalize_path(path)
          "/" + path.squeeze("/").gsub(/^\//, "")
        end
        
        def classify(path)
          path.
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