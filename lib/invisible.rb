require "rubygems"
require "time"
require "rack"
require "markaby"

require "invisible/core_ext"
require "invisible/application"

module Invisible
  VERSION = [0, 2, 0]
end

if __FILE__ == $PROGRAM_NAME
  class Crap
    def initialize(app)
      @app = app
    end
    
    def call(env)
      puts ">>>>> crap!"
      @app.call(env)
    end
  end
  
  app = Invisible::Application.new do
    get do
      response.write "root"
    end
    
    resource "ohaie" do
      use Crap
      
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
  Thin::Server.start(app, 5000)
end