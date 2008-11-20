module Invisible
  module Resource
    include Routing
    extend Forwardable
    
    attr_accessor :pipeline, :path, :actions, :resources
    
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
      @resources.sort! { |x,y| x.path.size <=> y.path.size }.reverse!
      
      resource
    end
    
    HTTP_METHODS.each do |method|
      module_eval <<-EOS
        def #{method}(path="/", &block)
          klass = path == "/" ? self : resource(path)
          klass.actions["#{method.to_s.upcase}"] = klass.new("#{method.to_s.upcase}", &block)
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
      
      if action = dispatch(request)
        action.prepare(request).call(env)
      else
        Response.new("Not found", 404).finish
      end
    end
    
    def prepare(request)
      self
    end
    
    private
      def init(path)
        @pipeline  = Pipeline.new
        @path      = path
        @route     = build_route(path)
        @actions   = {}
        @resources = []
      end
      
      def normalize_path(path)
        "/" + path.squeeze("/").gsub(/^\//, "")
      end
  end
end