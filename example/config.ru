$:.unshift File.dirname(__FILE__) + "/../lib"
require "invisible"
require "invisible/erb"
require "invisible/reloader"

Invisible.run do
  load "app"
  
  use Invisible::Reloader, self
  use Rack::ShowExceptions
  use Rack::CommonLogger
  use Rack::Session::Cookie # For session support
  use Rack::Static, :urls => %w(/css /js /images), :root => File.dirname(__FILE__) + "/public" # To serve static files
end
