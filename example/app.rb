# helpers
def time_helper
  Time.now.to_s
end

# views
layout { erb(:layout) }

# actions
get "/" do
  render do
    h2 "Welcome, it's #{time_helper}"
    p params["oh"]
    p session["stuff"]
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
