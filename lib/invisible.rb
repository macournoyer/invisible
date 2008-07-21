require "rubygems"
require "thin"
require "markaby"

# = The Invisible framework class
# If Camping was a micro-framwork at 4K then Invisible is a pico-framework of 2K.
# Half the size mainly because of Rack. Many ideas were barrowed from Sinatra,
# but with a few more opinions on my own and a strong emphasis on compactness.
#
# == Build an app in an object
# Invisible supports multiple applications running in the same VM. Each instance
# of this class represents a runnable application.
#
#  app = Invisible.new do
#    get "/" do
#      render "ohaie"
#    end
#  end
#
# == Build an app in a file
# DSL like Sinatra is also supported, put all your `get`, `post`, `layout` in your
# naked file and Invisible will do the method_missing magic for you.
#
# == Your app is a Rack config file (or not)
# Often the problem with new frameworks is you have to find how to deploy it.
# You either can make your app file standalone and runnable on its own, put this
# at the end of your file:
# 
#  app.run
# 
# Or to use as a Rack config file, switch the 2 and remove the dot
# 
#  run app
# 
# Then you'll be able to run with Thin:
# 
#  thin start -R app.ru
# 
class Invisible
  HTTP_METHODS = [:get, :post, :head, :put, :delete]
  attr_reader :request, :params
  
  def initialize(&block)
    @actions = []
    @layouts = {}
    @views   = {}
    @helpers = Module.new
    @app     = self
    instance_eval(&block) if block
  end
  
  def process(method, route, &block)
    @actions << [method.to_s, build_route(route), block]
  end
  HTTP_METHODS.each { |m| class_eval "def #{m}(r, &b); process('#{m}', r, &b) end" }
  
  # Render the response.
  # Render markaby by passing a block:
  #
  #  render "some text"
  # 
  # or simple text as the first argument.
  # 
  #  render "some text"
  #
  def render(*args, &block)
    options = args.last.is_a?(Hash) ? args.pop : {}
    status  = options.delete(:status) || 200
    layout  = @layouts[options.delete(:layout) || :default]
    assigns = { :request => request, :params => params, :session => session }
    content = args.last.is_a?(String) ? args.last : Markaby::Builder.new(assigns, @helpers, &(block || @views[args.last])).to_s
    content = Markaby::Builder.new(assigns.merge(:content => content), @helpers, &layout).to_s if layout
    [status, options, content]
  end
  
  def layout(name=:default, &block)
    @layouts[name] = block
  end
  
  def helpers(&block)
    @helpers.instance_eval(&block)
    instance_eval(&block)
  end
  
  def view(name, &block)
    @views[name] = block
  end
  
  def call(env)
    @request = Rack::Request.new(env)
    @params  = @request.params
    if action = recognize(env["PATH_INFO"], @params["_method"] || env["REQUEST_METHOD"])
      @params.merge!(@path_params)
      action.last.call
    else
      [404, {}, "Not found"]
    end
  end
  
  # Add `use Rack::Session::Cookie` to use
  def session
    @request.env["rack.session"]
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
        method == m && @path_params = match_route(pattern, keys, url)
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
