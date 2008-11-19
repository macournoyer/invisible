require "rubygems"
require "time"
require "forwardable"
require "rack"

$:.unshift File.expand_path(File.dirname(__FILE__))

module Invisible
  VERSION      = [0, 2, 0]
  HTTP_METHODS = [:get, :post, :put, :delete]
  
  def self.version
    VERSION.join(".")
  end
  
  def self.new(&block)
    Application.new(&block)
  end
  
  require "invisible/core_ext"
  require "invisible/middleware"
  
  autoload :Action,          "invisible/action"
  autoload :Application,     "invisible/application"
  autoload :Context,         "invisible/context"
  autoload :Middlewares,     "invisible/middlewares"
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
