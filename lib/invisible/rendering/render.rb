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
  @content = args.last.is_a?(String) ? args.last : mab(&(block || @views[args.last]))
  @content = mab(&layout).to_s if layout
  
  # Set headers
  @response.headers.merge!(options)
  @response.headers["Content-Length"] ||= @content.size.to_s
  @response.headers["Last-Modified"]  ||= Time.now.httpdate
  @response.body = @content
end
