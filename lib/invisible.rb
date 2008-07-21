require "rubygems"
require "thin"
require "markaby"

class Invisible
  HTTP_METHODS = [:get, :post, :head, :put, :delete]
  attr_reader :request, :actions
  
  def initialize(&block)
    @actions = []
    @layouts = {}
    @app     = self
    instance_eval(&block) if block
  end
  
  def process(method, route, &block)
    @actions << [method.to_s, route, block]
  end
  HTTP_METHODS.each { |m| class_eval "def #{m}(r, &b); process('#{m}', r, &b) end" }
  
  def render(*args, &block)
    status  = args.first.is_a?(Fixnum) ? args.shift : 200
    options = args.last.is_a?(Hash) ? args.pop : {}
    if block
      layout  = @layouts[options.delete(:layout) || :default]
      assigns = { :request => @request }
      content = Markaby::Builder.new(assigns, nil, &block).to_s
      content = Markaby::Builder.new(assigns.merge(:content => content), nil, &layout).to_s if layout
    else
      content = args.last
    end
    [status, options, content]
  end
  
  def layout(name=:default, &block)
    @layouts[name] = block
  end
  
  def call(env)
    @request = Rack::Request.new(env)
    params = nil
    action = @actions.detect { |method, route, _| env["REQUEST_METHOD"].downcase == method && params = env["PATH_INFO"].match(route) }
    
    if action
      action.last.call(*params[1..-1])
    else
      [404, {}, "Not found"]
    end
  end
  
  def use(middleware, *args)
    @app = middleware.new(@app, *args)
  end
  
  def run(*args)
    Thin::Server.start(@app, *args)
  end
  
  def self.run(*args, &block)
    new(&block).run(*args)
  end
  
  def self.app
    @app ||= self.new
  end
  
  def self.call(env)
    @app.call(env)
  end
end

def method_missing(method, *args, &block)
  if Invisible.app.respond_to?(method)
    Invisible.app.send(method, *args, &block)
  else
    super
  end
end
