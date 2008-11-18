require "rubygems"
require "time"
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
require "invisible/rendering"
require "invisible/action"
require "invisible/resource"
require "invisible/context"
require "invisible/middleware/base"
require "invisible/middleware/before"
require "invisible/middleware/layout"
require "invisible/middleware/content_length"


if __FILE__ == $PROGRAM_NAME
  app = Invisible::Application.new do
    get do
      render "root"
    end
    
    resource "ohaie" do
      layout :default
      
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
          render "ohaie/there"
        end
      end
    end
  end
  
  require "thin"
  Thin::Logging.debug = true
  Thin::Server.start(app, 5000)
end