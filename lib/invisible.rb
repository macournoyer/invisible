require "rubygems"
require "time"
require "forwardable"
require "rack"
require "markaby"

$:.unshift File.dirname(__FILE__)
require "invisible/core_ext"

module Invisible
  VERSION = [0, 2, 0]
  
  HTTP_METHODS = [:get, :post, :put, :delete]
  
  def self.new(&block)
    Application.new(&block)
  end
end

require "invisible/application"
require "invisible/request"
require "invisible/response"
require "invisible/rendering"
require "invisible/action"
require "invisible/pipeline"
require "invisible/resource"
require "invisible/context"
require "invisible/middleware"
require "invisible/middleware/before"
require "invisible/middleware/layout"
require "invisible/middleware/content_length"


if __FILE__ == $PROGRAM_NAME
  app = Invisible.new do
    get do
      render "root"
    end
    
    resource "ohaie" do
      # layout :default
      
      before do
        puts ">> in ohaie"
      end
      
      get do
        render "ohaie"
      end
      
      get "lol" do
        render "ohaie/lol"
      end
      
      resource "private" do
        use Rack::Auth::Basic do |user, password|
          true
        end
        
        get do
          render "ohaie, this is private!"
        end
        
        get "rly" do
          render "rly, it is!"
        end
      end
    end
  end
  
  require "thin"
  Thin::Logging.debug = true
  Thin::Server.start(app, 5000)
end