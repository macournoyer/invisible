require "erb"

class Invisible
  include ERB::Util
  
  def view_root(root)
    @view_root = File.join(@root, root.to_s)
  end
  
  def erb(file)
    view_root "views" unless @view_root
    path = File.join(@view_root, file.to_s)
    ERB.new(File.read("#{path}.erb")).result(binding)
  end
end