$:.unshift File.dirname(__FILE__) + "/../lib"
require "invisible"

helpers do
  def time
    Time.now.to_s
  end
end

layout do
  html do
    body do
      h1 "Ohaie"
      text content
    end
  end
end

with "/echo" do
  get "/:stuff" do
    session["stuff"] = params["stuff"]
    render do
      h2 "I echo stuff!"
      p params['stuff']
    end
  end
end

get "/" do
  render do
    h2 "Welcome, it's #{@helpers.time}"
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