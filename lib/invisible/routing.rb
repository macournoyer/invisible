module Invisible
  module Routing
    class Route
      attr_reader :path, :params
      
      def initialize(path)
        @path = path
        compile
      end
      
      def compile
        pattern              = '^\/*' + @path.gsub("/", '\/*').gsub(/:\w+/, '(\w+)') + '\/*'
        @match_pattern       = /#{pattern}$/i
        @starts_with_pattern = /#{pattern}/i
        @params              = @path.scan(/\:(\w+)/).flatten
      end
      
      def match(path_info)
        path_info.match(@match_pattern)
      end
      
      def starts_with?(path_info)
        !path_info.match(@starts_with_pattern).nil?
      end
      
      def extract_params(path_info)
        if matches = match(path_info)
          path_params = {}
          @params.each_with_index { |key, i| path_params[key] = matches[i+1] }
          path_params.symbolize_keys
        end
      end
      
      def to_filename
        @path.delete(":")
      end
    end
    
    def route
      @route ||= Route.new(path)
    end
    
    def dispatch(request)
      if action = actions[request.request_method] and request.path_params = resource.route.extract_params(request.path_info)
        action
      else
        resources.detect { |resource| resource.route.starts_with?(request.path_info) }
      end
    end
  end
end