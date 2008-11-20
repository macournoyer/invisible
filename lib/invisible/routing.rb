module Invisible
  module Routing
    class Route
      attr_reader :path, :pattern, :params
      
      def initialize(path)
        @path = path
        compile
      end
      
      def compile
        pattern  = '\/*' + @path.gsub("/", '\/*').gsub(/:\w+/, '(\w+)') + '\/*'
        @pattern = /^#{pattern}$/i
        @params  = @path.scan(/\:(\w+)/).flatten
      end
      
      def match(path_info)
        path_info.match(@pattern)
      end
      
      def extract_params(path_info)
        if matches = match(path_info)
          path_params = {}
          @params.each_with_index { |key, i| path_params[key] = matches[i+1] }
          path_params.symbolize_keys
        end
      end
    end
    
    def route
      @route ||= Route.new(path)
    end
    
    def dispatch(request)
      if action = actions[request.request_method] and request.path_params = resource.route.extract_params(request.path_info)
        action
      else
        resources.detect { |resource| resource.route.match(request.path_info) }
      end
    end
  end
end