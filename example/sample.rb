$:.unshift File.dirname(__FILE__) + "/../lib"
require "invisible"

layout do
  html do
    body do
      h1 "Ohaie"
      text content
    end
  end
end

get "/echo/:stuff" do
  session["stuff"] = params["stuff"]
  render do
    h2 "I echo stuff!"
    p params['stuff']
  end
end

get "/" do
  render do
    h2 "Welcome"
    p params["oh"]
    p session["stuff"]
  end
end

use Rack::ShowExceptions
use Rack::CommonLogger
use Rack::Session::Cookie

run

# or to run as a Rack config file (.ru)
#  run Invisible