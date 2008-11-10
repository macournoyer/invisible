class Invisible
  def link_to(title, url, options={})
    mab { a title, options.merge(:href => url) }
  end
end