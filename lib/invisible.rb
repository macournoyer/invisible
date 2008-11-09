%w(rubygems time rack markaby invisible/core_ext).each { |f| require f }
# = The Invisible Framework
# Invisible is like a giant robot combining the awesomeness of Rails,
# Merb, Camping and Sinatra. Except, it's tiny (100 sloc).
# 
# == Build an app in an object
# Invisible supports multiple applications running in the same VM. Each instance
# of this class represents a runnable application.
#
#   app = Invisible.new do
#     get "/" do
#       render "ohaie"
#     end
#   end
# 
# You can then run it as a Rack application.
# 
#   run app
# 
class Invisible
  HTTP_METHODS = [:get, :post, :head, :put, :delete]
  attr_reader :actions, :request, :response, :params
  
  # Creates a new Invisible Rack application. You can build your app
  # in the yielded block or using the app instance.
  def initialize(&block)
    @actions, @with, @loaded, @layouts, @views, @helpers, @app = [], [], [], {}, {}, self, method(:_call)
    @root = File.dirname(eval("__FILE__", block.binding))
    instance_eval(&block)
  end
  
  # Set the root of the app.
  # Defaults to the file the Invisible class is instancianted in.
  def root(value=@root)
    @root = value
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
  #   render do
  #     h1 "Poop"
  #     p "Smells!"
  #   end
  # 
  # or simple text as the first argument:
  # 
  #   render "crap"
  # 
  # or render a markaby view, created using the +view+ method:
  # 
  #   view :lolcat do
  #     p "i can has?"
  #   end
  #   render :lolcat
  # 
  # You can also pass some options or headers:
  # 
  #   render "heck", :status => 201, :layout => :none, 'X-Crap-Level' => 'ubersome'
  #
  # Supported options are:
  # status: Status code of the response.
  # layout: Name of the layout to use.
  # All other options will be sent as a response header.
  def render(*args, &block)
    options  = args.last.is_a?(Hash) ? args.pop : {}
    
    # Extract options
    layout   = @layouts[options.delete(:layout) || :default]
    @response.status = options.delete(:status) || 200
    
    # Render inside the layout
    @content = args.last.is_a?(String) ? args.last : Markaby::Builder.new({}, self, &(block || @views[args.last])).to_s
    @content = Markaby::Builder.new({}, self, &layout).to_s if layout
    
    # Set headers
    @response.headers.merge!(options)
    @response.headers["Content-Length"] ||= @content.size.to_s
    @response.headers["Last-Modified"]  ||= Time.now.httpdate
    @response.body = @content
  end
  
  # Redirect to a path.
  # 
  #   redirect_to "/login"
  # 
  # To do a permanent redirect, specify the status code as the last argument.
  # 
  #   redirect_to "/", 301
  # 
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
  
  # Load an external file inside the context of Invisible,
  # which means you can use the get,post,with methods.
  # The files loaded with this method will be reloaded in
  # You're using the Invisible Reloader middleware.
  def load(file)
    return if @loaded.include?(file)
    @loaded << file
    path = File.join(@root, file) + ".rb"
    eval(File.read(path), binding, path)
  end
  
  # Shortcut to Rack builder +run+ method.
  # Equivalent to:
  # 
  # app = Invisible.new do
  #   ...
  # end
  # run app
  # 
  def self.run(*args, &block)
    eval("self", block.binding).run new(&block)
  end
  
  private
    def _call(env)
      @request  = Rack::Request.new(env)
      @response = Rack::Response.new
      @params   = @request.params.symbolize_keys
      if action = recognize(@request.path_info, @request.POST["_method"] || @request.request_method)
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
