require "erb"

class Invisible
  def view_root(root)
    @view_root = root.to_s
  end
  
  def erb(file)
    path = File.join(@view_root, file.to_s)
    ERB.new(File.read("#{path}.erb")).result(binding)
  end
end