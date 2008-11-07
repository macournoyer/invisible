require "rubygems"
require "invisible"

# Optional Invisible libs
require "invisible/erb"

RACK_ENV = ENV["RACK_ENV"] || "development"

Invisible.run do
  root File.dirname(__FILE__) + "/.."
  
  puts "Booting #{RACK_ENV} environment"
  load "config/env/#{RACK_ENV}"
  
  load "app"
  
  # For session support
  use Rack::Session::Cookie
  
  # To serve static files
  use Rack::Static, :urls => %w(/stylesheets /javascripts /images),
                    :root => root + "/public"
end
