require "rubygems"
require "invisible"

RACK_ENV = ENV["RACK_ENV"] ||= "development"

Invisible.run do
  if RACK_ENV == "development"
    require "invisible/reloader"
    
    use Invisible::Reloader, self
    use Rack::ShowExceptions
    use Rack::CommonLogger
    use Rack::Lint
  end
  
  load "app"
end
