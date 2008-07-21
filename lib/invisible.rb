require "rubygems"
require "thin"
require "markaby"

class Invisible
  HTTP_METHODS = [:get, :post, :head, :put, :delete]
  attr_reader :request, :params
  
  def initialize(&block)
    @actions = []
    @layouts = {}
    @app     = self
    instance_eval(&block) if block
  end
  
  def process(method, route, &block)
    @actions << [method.to_s, build_route(route), block]
  end
  HTTP_METHODS.each { |m| class_eval "def #{m}(r, &b); process('#{m}', r, &b) end" }
  
  def render(*args, &block)
    status  = args.first.is_a?(Fixnum) ? args.shift : 200
    options = args.last.is_a?(Hash) ? args.pop : {}
    layout  = @layouts[options.delete(:layout) || :default]
    assigns = { :request => @request, :params => params }
    content = block ? Markaby::Builder.new(assigns, nil, &block).to_s : args.last
    content = Markaby::Builder.new(assigns.merge(:content => content), nil, &layout).to_s if layout
    [status, options, content]
  end
  
  def layout(name=:default, &block)
    @layouts[name] = block
  end
  
  def call(env)
    @request = Rack::Request.new(env)
    if action = recognize(env["PATH_INFO"], env["REQUEST_METHOD"])
      action.last.call
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
  
  private
    def build_route(route)
      pattern = route.split("/").inject('\/*') { |r, s| r << (s[0] == ?: ? '(\w+)' : s) + '\/*' } + '\/*'
      [/^#{pattern}$/i, route.scan(/\:(\w+)/).flatten]
    end
    
    def recognize(url, method)
      method = method.to_s.downcase
      @actions.detect do |m, (pattern, keys), _|
        method == m && @params = match_route(pattern, keys, url)
      end
    end
    
    def match_route(pattern, keys, url)
      matches, params = (url.match(pattern) || return)[1..-1], {}
      keys.each_with_index { |key, i| params[key] = matches[i] }
      params
    end
end

def method_missing(method, *args, &block)
  if Invisible.app.respond_to?(method)
    Invisible.app.send(method, *args, &block)
  else
    super
  end
end
