require "rubygems"
require "time"
require "rack"
require "markaby"

$:.unshift File.dirname(__FILE__)
require "invisible/core_ext"
require "invisible/application"
require "invisible/rendering"
require "invisible/action"
require "invisible/resource"
require "invisible/context"

module Invisible
  VERSION = [0, 2, 0]
  
  HTTP_METHODS = [:get, :post, :put, :delete]
  
  def self.new(&block)
    Application.new(&block)
  end
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
      render "root"
    end
    
    resource "ohaie" do
      use Crap
      
      get do
        render "ohaie"
      end
      
      get "lol" do
        render "ohaie/lol"
      end
      
      resource "there" do
        get do
          render "ohaie/there"
        end
      end
    end
  end
  
  require "thin"
  Thin::Logging.debug = true
  Thin::Server.start(app, 5000)
end