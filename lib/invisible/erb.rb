require "erb"

class Invisible
  include ERB::Util
  
  # Evaluate the ERB template in +file+ and returns the
  # result as a string.
  # Use with +render+:
  # 
  #   render erb(:muffin)
  # 
  def erb(file)
    path = File.join(@root, "views", file.to_s)
    ERB.new(File.read("#{path}.erb")).result(binding)
  end
end