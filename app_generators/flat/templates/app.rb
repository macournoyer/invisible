layout do
  html do
    head do
      title 'Invisible'
    end
    body do
      self << @content
    end
  end
end

get "/" do
  render do
    h1 "This is Invisible"
  end
end
