# Optional Invisible libs
require "invisible/erb"

load "config/env/#{RACK_ENV}"
load "app"

# For session support
use Rack::Session::Cookie

# To serve static files
use Rack::Static, :urls => %w(/stylesheets /javascripts /images),
                  :root => root + "/public"
