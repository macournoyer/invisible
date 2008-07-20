require "rubygems"
require "thin"
require "markaby"

class Invisible
  def initialize(&block)
    @actions = []
    @layouts = {}
    instance_eval(&block)
  end
  
  def process(method, route, &block)
    @actions << [method.to_s, route, block]
  end
  def get(route, &b);  process("get",  route, &b) end
  def post(route, &b); process("post", route, &b) end
  
  def render(status=200, options_and_headers={}, &block)
    layout  = @layouts[options_and_headers.delete(:layout) || :default]
    content = Markaby::Builder.new.capture(&block)
    content = Markaby::Builder.new({ :content => content }, nil, &layout).to_s
    [status, options_and_headers, content]
  end
  
  def layout(name=:default, &block)
    @layouts[name] = block
  end
  
  def call(env)
    params = nil
    action = @actions.detect { |method, route, _| env["REQUEST_METHOD"].downcase == method && params = env["PATH_INFO"].match(route) }
    
    if action
      action.last.call(*params[1..-1])
    else
      [404, {}, "Not found"]
    end
  end
  
  def run(*args)
    app = self
    Thin::Server.start(*args) do
      use Rack::ShowExceptions
      use Rack::CommonLogger
      run app
    end
  end
  
  def self.run(*args, &block)
    new(&block).run(*args)
  end
end

