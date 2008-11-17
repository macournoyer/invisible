require "rubygems"
require "time"
require "rack"
require "markaby"

require "invisible/core_ext"
require "invisible/application"
require "invisible/action"
require "invisible/resource"

module Invisible
  VERSION = [0, 2, 0]
end

if __FILE__ == $PROGRAM_NAME
  app = Invisible::Application.new do
    get do
      response.write "root"
    end
    
    resource "ohaie" do
      get do
        response.write "ohaie"
      end
      
      get "lol" do
        response.write "ohaie/lol"
      end
      
      resource "there" do
        get do
          response.write "ohaie/there"
        end
      end
    end
  end
  
  require "thin"
  Thin::Logging.debug = true
  Thin::Server.start(app)
end