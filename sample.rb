require "invisible"

Invisible.run do
  layout do
    html do
      body do
        h1 "Ohaie"
        text content
      end
    end
  end
  
  get /\/(\w+)/ do |path|
    render do
      h2 "Cool!"
      p "You went to #{path}"
    end
  end
  
  get "/" do
    render do
      h2 "Welcome"
    end
  end
end
