module Invisible
  module Routing
    attr_reader :route
    
    def dispatch(request)
      if action = actions[request.request_method] and request.path_params = match_route(request)
        action
      else
        resources.detect { |resource| request.path_info.index(resource.path) }
      end
    end
    
    protected
      def match_route(request)
        pattern, keys = @route
        
        if matches = request.path_info.match(pattern)
          path_params = {}
          keys.each_with_index { |key, i| path_params[key] = matches[i+1] }
          path_params.symbolize_keys
        end
      end
      
      def build_route(path)
        pattern = '\/*' + path.gsub("/", '\/*').gsub(/:\w+/, '(\w+)') + '\/*'
        [/^#{pattern}$/i, path.scan(/\:(\w+)/).flatten]
      end
  end
end