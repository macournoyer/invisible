$:.unshift File.dirname(__FILE__) + "/../lib"
require "invisible"
require "invisible/erb"

Invisible.run do
  view_root File.dirname(__FILE__)
  
  def time_helper
    Time.now.to_s
  end

  layout { erb(:layout) }

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
      h2 "Welcome, it's #{time_helper}"
      p params["oh"]
      p session["stuff"]
    end
  end

  use Rack::Static, :urls => %w(/style.css), :root => File.dirname(__FILE__) # To serve static files
  use Rack::ShowExceptions
  use Rack::CommonLogger
  use Rack::Session::Cookie # For session support
end
