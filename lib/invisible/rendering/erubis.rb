require "erubis"

class Invisible
  # Evaluate the Erubis template in +file+ and returns the
  # result as a string.
  # Use with +render+:
  # 
  #   render erb(:muffin)
  # 
  def erb(file)
    path = File.join(@root, "views", file.to_s)
    Erubis::Eruby.load_file("#{path}.erb").result(binding)
  end
end