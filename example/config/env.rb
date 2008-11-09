# Optional Invisible libs
require "invisible/erb"
# require "invisible/erubis" Remove previous if you uncomment this
# require "invisible/haml"

load "config/env/#{RACK_ENV}"

# If you want to split your app in several files,
# load all the files here.
load "app"

# Install middleware for session support.
# See http://rack.rubyforge.org/doc/classes/Rack/Session.html
use Rack::Session::Cookie

# To serve static files
use Rack::Static, :urls => %w(/stylesheets /javascripts /images),
                  :root => root + "/public"
