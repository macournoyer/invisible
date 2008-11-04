require "erb"

class Invisible
  def erb(file)
    ERB.new(File.read("#{file}.erb")).result(binding)
  end
end