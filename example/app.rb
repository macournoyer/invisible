# helpers
def invisible_helper
  "Invisible"
end

# views
layout { erb(:layout) }

# actions
get "/" do
  render do
    h1 "This is #{invisible_helper}"
    p params[:oh]
    pre "session:\n" + session.inspect
    p { a "Add stuff to your session", :href => "/session/bike" }
    p { a "Clear your session", :href => "/session/clear" }
  end
end

with "/session" do
  get "/clear" do
    session.clear
    redirect_to "/"
  end
  
  get "/:value" do
    session[:invisible] = params[:value]
    render do
      h2 "I added this to the session for you:"
      pre params[:value].inspect
      p { a "Go back", :href => "/" }
    end
  end
end
