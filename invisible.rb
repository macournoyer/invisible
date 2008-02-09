# Start w/ thin start -r invisible.rb
require 'tenjin'

module ::Invisible
  class Adapter
    def initialize
      @template = Tenjin::Engine.new(:postfix=>'.rbhtml', :layout=>'../layout.rbhtml', :path=>'home')
      @file = Rack::File.new('public')
    end  
    def call(env)
      path = env['PATH_INFO']
      if path.include?('.')
        @file.call(env)
      else
        _, controller, action = env['PATH_INFO'].split('/')
        Invisible.const_get("#{(controller || 'home').capitalize}Controller").new(@template, env).call(action || 'index')
      end
    end
  end
  class Controller
    def initialize(template, env)
      @template, @status, @env, @headers = template, 200, env, {'Content-Type' => 'text/html'}
    end
    def call(action)
      send(action)
      render(action) unless @body
      [@status, @headers.merge('Content-Length'=>@body.size.to_s), [@body]]
    end
    protected
      def render(action=nil)
        @body = @template.render(action.to_sym, instance_variables.inject({}) {|h,v| h[v[1..-1]] = instance_variable_get(v); h})
      end
  end
end

require 'app/controllers'
run Invisible::Adapter.new