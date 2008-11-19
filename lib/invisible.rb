require "rubygems"
require "time"
require "forwardable"
require "rack"
require "markaby"

$:.unshift File.expand_path(File.dirname(__FILE__))

module Invisible
  VERSION = [0, 2, 0]
  
  def self.version
    VERSION.join(".")
  end
  
  HTTP_METHODS = [:get, :post, :put, :delete]
  
  def self.new(&block)
    Application.new(&block)
  end
  
  require "invisible/core_ext"
  require "invisible/middleware"
  
  autoload :Action,          "invisible/action"
  autoload :Application,     "invisible/application"
  autoload :Context,         "invisible/context"
  autoload :Pipeline,        "invisible/pipeline"
  autoload :Rendering,       "invisible/rendering"
  autoload :Request,         "invisible/request"
  autoload :Resource,        "invisible/resource"
  autoload :Response,        "invisible/response"
  autoload :Routing,         "invisible/routing"
  
  module Middleware
    autoload :Before,        "invisible/middleware/before"
    autoload :ContentLength, "invisible/middleware/content_length"
    autoload :Layout,        "invisible/middleware/layout"
    autoload :Reloader,      "invisible/middleware/reloader"
  end
end

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