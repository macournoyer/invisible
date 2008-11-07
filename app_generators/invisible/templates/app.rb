layout { erb(:layout) }

get "/" do
  render do
    h1 "This is Invisible"
  end
end
