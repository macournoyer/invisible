require "rubygems"
require "thin"
require "markaby"

# = The Invisible framework class
# If Camping is a micro-framwork at 4K then Invisible is a pico-framework of 2K.
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
  attr_reader :request, :response, :params
  
  # Creates a new Invisible Rack application. You can build your app
  # in the yielded block or using the app instance.
  def initialize(&block)
    @actions = []
    @with    = []
    @layouts = {}
    @views   = {}
    @helpers = Module.new
    @app     = self
    instance_eval(&block) if block
  end
  
  # Register an action for a specified +route+.
  # 
  #  get "/" do
  #    # ...
  #  end
  #
  def action(method, route, &block)
    @actions << [method.to_s, build_route(@with.join("/") + route), block]
  end
  HTTP_METHODS.each { |m| class_eval "def #{m}(r='/', &b); action('#{m}', r, &b) end" }
  
  # Wrap actions sharing a common base route.
  #
  #  with "/lol" do
  #    get "/cat" # ...
  #  end
  #
  # Will register an action on GET /lol/cat.
  # You can nested as many level as you want.
  def with(route)
    @with.push(route)
    yield
    @with.pop
  end
  
  # Render the response inside an action.
  # Render markaby by passing a block:
  #
  #  render do
  #    h1 "Poop"
  #    p "Smells!"
  #  end
  # 
  # or simple text as the first argument.
  # 
  #  render "crap"
  #
  # You can also pass some option or headers:
  #
  #  render "heck", :status => 201, :layout => :none, 'X-Crap-Level' => 'ubersome'
  #
  def render(*args, &block)
    options = args.last.is_a?(Hash) ? args.pop : {}
    @response.status = options.delete(:status) || 200
    layout  = @layouts[options.delete(:layout) || :default]
    assigns = { :request => request, :response => response, :params => params, :session => session }
    content = args.last.is_a?(String) ? args.last : Markaby::Builder.new(assigns, @helpers, &(block || @views[args.last])).to_s
    content = Markaby::Builder.new(assigns.merge(:content => content), @helpers, &layout).to_s if layout
    @response.headers.merge!(options)
    @response.body = content
  end
  
  # Register a layout to be used around +render+ed text.
  # Use markaby inside your block.
  def layout(name=:default, &block)
    @layouts[name] = block
  end
  
  # Register a named view to be used from <tt>render :name</tt>.
  # Use markaby inside your block.
  def view(name, &block)
    @views[name] = block
  end
  
  # Define helper methods to be used inside the actions and inside
  # the views.
  # Inside markaby, helpers are added to the @helpers object:
  #
  #  my_helper
  #  render do
  #    @helpers.my_helper
  #  end
  #
  def helpers(&block)
    @helpers.instance_eval(&block)
    instance_eval(&block)
  end
  
  # Return the current session.
  # Add `use Rack::Session::Cookie` to use.
  def session
    @request.env["rack.session"]
  end
  
  # Register a Rack middleware wrapping the
  # current application.
  def use(middleware, *args)
    @app = middleware.new(@app, *args)
  end
  
  # Run the application using Thin.
  # All arguments are passed to Thin::Server.start.
  def run(*args)
    Thin::Server.start(@app, *args)
  end
  
  # Called by the Rack handler to process a request.
  def call(env)
    @request  = Rack::Request.new(env)
    @response = Rack::Response.new
    @params   = @request.params
    if action = recognize(env["PATH_INFO"], @params["_method"] || env["REQUEST_METHOD"])
      @params.merge!(@path_params)
      action.last.call
      @response.finish
    else
      [404, {}, "Not found"]
    end
  end
  
  # Allow to defined and run an application in a single call.
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
