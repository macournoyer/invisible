module Invisible
  module Resource
    extend Forwardable
    
    attr_accessor :pipeline, :path, :methods, :resources
    
    def_delegators :pipeline, :use
    
    def create(path, &block)
      init(path)
      resource(path, &block)
    end
    
    def resource(path="/", &block)
      path = normalize_path(@path.to_s + "/" + path)
      
      resource = subclass("Resource") do
        init(path)
        module_eval(&block) if block
      end
      
      @resources << resource
      @resources.sort! { |x,y| x.path <=> y.path }.reverse!
      
      resource
    end
    
    HTTP_METHODS.each do |method|
      module_eval <<-EOS
        def #{method}(path=nil, &block)
          klass = path ? resource(path) : self
          klass.methods["#{method.to_s.upcase}"] = klass.new("#{method.to_s.upcase}", &block)
        end
      EOS
    end
    
    def call(env)
      request = Request.new(env)
      
      if request.pipeline
        request.pipeline = @pipeline.merge(request.pipeline)
      else
        request.pipeline = @pipeline
      end
      
      if @path == request.path_info && method = methods[request.request_method] # TODO match
        request.context = method
        response = request.pipeline.apply(method).call(env)
      elsif resource = resources.detect { |resource| request.path_info.index(resource.path) }
        response = resource.call(env)
      end
      
      response || Rack::Response.new("Not found", 404).finish
    end
    
    def before(&block)
      use Middleware::Before, &block
    end
    
    def layout(name)
      use Middleware::Layout, name
    end
    
    private
      def init(path)
        @pipeline  = Pipeline.new
        @path      = path
        @methods   = {}
        @resources = []
      end
      
      def normalize_path(path)
        "/" + path.squeeze("/").gsub(/^\//, "")
      end
  end
end