module Invisible
  module Routing
    def match(request)
      if request.request_method == @method && matches = request.path_info.match(@pattern)
        path_params = {}
        @params.each_with_index { |key, i| path_params[key] = matches[i+1] }
        path_params.symbolize_keys
      end
    end
    
    def build_route(route)
      pattern = '\/*' + route.gsub("*", '.*').gsub("/", '\/*').gsub(/:\w+/, '(\w+)') + '\/*'
      [/^#{pattern}$/i, route.scan(/\:(\w+)/).flatten]
    end
  end
end