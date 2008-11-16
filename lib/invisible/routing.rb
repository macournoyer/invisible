module Invisible
  module Routing
    def build_route(route)
      pattern = '\/*' + route.gsub("*", '.*').gsub("/", '\/*').gsub(/:\w+/, '(\w+)') + '\/*'
      [/^#{pattern}$/i, route.scan(/\:(\w+)/).flatten]
    end
    
    def recognize(url, method)
      method = method.to_s.downcase
      @actions.detect do |m, (pattern, keys), _|
        method == m && @path_params = match_route(pattern, keys, url)
      end
    end
    
    def match_route(pattern, keys, url)
      matches, params = (url.match(pattern) || return)[1..-1], {}
      keys.each_with_index { |key, i| params[key] = matches[i] }
      params.symbolize_keys
    end
  end
end