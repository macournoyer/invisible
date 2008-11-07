%w(rubygems rack markaby invisible/core_ext).each { |f| require f }
# = The Invisible framework class
# If Camping is a micro-framwork at 4K then Invisible is a pico-framework of 2K.
# Half the size mainly because of Rack. Many ideas were borrowed from Sinatra,
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
  attr_reader :actions, :request, :response, :params, :root
  
  # Creates a new Invisible Rack application. You can build your app
  # in the yielded block or using the app instance.
  def initialize(&block)
    @actions, @with, @loaded, @layouts, @views, @helpers = [], [], [], {}, {}, self
    @app  = method(:_call)
    @root = File.dirname(eval("__FILE__", block.binding))
    instance_eval(&block)
  end
  
  # Register an action for a specified +route+.
  # 
  #  get "/" do
  #    # ...
  #  end
  #
  def action(method, route, &block)
    @actions << [method.to_s, build_route(@with * "/" + route), block]
  end
  HTTP_METHODS.each { |m| class_eval "def #{m}(r='/',&b); action('#{m}', r, &b) end" }
  
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
    options  = args.last.is_a?(Hash) ? args.pop : {}
    layout   = @layouts[options.delete(:layout) || :default]
    @response.status = options.delete(:status) || 200
    @response.headers.merge!(options)
    @content = args.last.is_a?(String) ? args.last : Markaby::Builder.new({}, self, &(block || @views[args.last])).to_s
    @content = Markaby::Builder.new({}, self, &layout).to_s if layout
    @response.body = @content
  end
  
  # Redirect to a path
  def redirect_to(path, status=302)
    render(:status => status, "Location" => path) { p { text("You are redirected to "); a(path, :href => path) } }
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
  
  # Called by the Rack handler to process a request.
  def call(env)
    @app.call(env)
  end
  
  # Load an external file that will be reloaded
  def load(file)
    @loaded << file
    path = File.join(@root, file) + ".rb"
    eval(File.read(path), binding, path)
  end
  
  # Shortcut to Rack builder +run+ method.
  def self.run(*args, &block)
    eval("self", block.binding).run new(&block)
  end
  
  private
    def _call(env)
      @request  = Rack::Request.new(env)
      @response = Rack::Response.new
      @params   = @request.params.symbolize_keys
      if action = recognize(env["PATH_INFO"], @params[:_method] || env["REQUEST_METHOD"])
        @params.merge!(@path_params)
        instance_eval(&action.last)
        @response.finish
      else
        [404, {}, "Not found"]
      end
    end
    
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
      params.symbolize_keys
    end
end
