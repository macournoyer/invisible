module Invisible
  class Action
    class Runtime
      attr_reader :request, :response, :params, :path_params
      
      def initialize(request, path_params, response)
        @request     = request
        @path_params = path_params
        @params      = request.params.symbolize_keys
        @params.merge!(@path_params)
        @response    = response
      end
    end
    
    attr_reader :method, :route, :block
    
    def initialize(context, method, route, &block)
      @context = context
      @method  = method.to_s.upcase
      @route   = route
      @block   = block
      @pattern, @params = build_route(route)
    end
    
    def match(request)
      if request.request_method == @method && matches = request.path_info.match(@pattern)
        path_params = {}
        @params.each_with_index { |key, i| path_params[key] = matches[i+1] }
        path_params.symbolize_keys
      end
    end
    
    def call(env)
      request = Rack::Request.new(env)
      if path_params = match(request)
        response = Rack::Response.new
        Runtime.new(request, path_params, response).instance_eval(&@block)
        response.finish
      end
    end
    
    private
      def build_route(route)
        pattern = '\/*' + route.gsub("*", '.*').gsub("/", '\/*').gsub(/:\w+/, '(\w+)') + '\/*'
        [/^#{pattern}$/i, route.scan(/\:(\w+)/).flatten]
      end
  end
end