$:.unshift File.dirname(__FILE__) + "/../lib"
require "invisible"

Invisible.run do
  def time_helper
    Time.now.to_s
  end

  layout do
    instruct!
    xhtml_transitional do
      head do
        title "You don't see this, it's invisible"
        link :href => "/style.css", :media => "screen", :rel => "stylesheet", :type => "text/css"
      end
      body do
        h1 "Ohaie"
        text @content
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

  get "/style.css" do
    render <<-EOS, 'Content-Type' => 'text/css', :layout => :none
      body, p, ol, ul, td { font-family: verdana, arial, helvetica, sans-serif }
    EOS
  end

  get "/" do
    render do
      h2 "Welcome, it's #{time_helper}"
      p params["oh"]
      p session["stuff"]
    end
  end

  use Rack::Static, :urls => %w(/stylesheets /images), :root => "public" # To serve static files
  use Rack::ShowExceptions
  use Rack::CommonLogger
  use Rack::Session::Cookie # For session support
end
