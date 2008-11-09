require "haml"

class Invisible
  # Evaluate the Haml template in +file+ and returns the
  # result as a string.
  # Use with +render+:
  # 
  #   render haml(:muffin)
  # 
  def haml(file)
    path = File.join(@root, "views", file.to_s)
    Haml::Engine.new(File.read("#{path}.haml")).render(self)
  end
end