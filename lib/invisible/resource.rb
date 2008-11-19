module Invisible
  module Resource
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
        def #{method}(path=nil, &block)
          klass = path ? resource(path) : self
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
      
      if @path == request.path_info && action = actions[request.request_method] # TODO match
        request.context = action
        action.prepare(env)
        response = request.pipeline.apply(action).call(env)
      elsif resource = resources.detect { |resource| request.path_info.index(resource.path) }
        response = resource.call(env)
      end
      
      response || Rack::Response.new("Not found", 404).finish
    end
    
    private
      def init(path)
        @pipeline  = Pipeline.new
        @path      = path
        @actions   = {}
        @resources = []
      end
      
      def normalize_path(path)
        "/" + path.squeeze("/").gsub(/^\//, "")
      end
  end
end