ENV["RACK_ENV"] = "test"
require File.dirname(__FILE__) + "/../config/boot"
require "invisible/mock"
require "test/unit"

class Test::Unit::TestCase
  include Invisible::MockMethods
  
  def setup
    @app = Invisible.new do
      root File.dirname(__FILE__) + "/.."
      load "config/env"
    end
  end
end
