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
      attr_accessor :app, :path, :methods, :resources
      
      def create(path, &block)
        init(path)
        resource(path, &block)
      end
      
      def get(path=nil, &block)
        klass = path ? resource(path) : self
        klass.methods["GET"] = klass.new("GET", &block)
      end
      
      def resource(path="/", &block)
        resource_name = classify(path)
        path          = normalize_path(@path.to_s + "/" + path)
        
        resource = subclass(resource_name) do
          init(path)
          module_eval(&block) if block
        end
        
        @resources << resource
        @resources.sort! { |x,y| x.path <=> y.path }.reverse!
        
        resource
      end
      
      def call(env)
        @app.call(env)
      end
      
      def use(middleware, *args, &block)
        @app = middleware.new(@app, *args, &block)
      end
      
      private
        def init(path)
          @app       = method(:call_app)
          @path      = path
          @methods   = {}
          @resources = []
        end
        
        def call_app(env)
          request = Rack::Request.new(env)
          
          if @path == request.path_info && method = methods[request.request_method] # TODO match
            response = method.call(env)
          elsif resource = resources.detect { |resource| request.path_info.index(resource.path) }
            response = resource.call(env)
          end
          response || Rack::Response.new("Not found", 404).finish
        end
        
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