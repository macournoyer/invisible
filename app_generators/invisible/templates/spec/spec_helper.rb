ENV["RACK_ENV"] = "test"
require File.dirname(__FILE__) + "/../config/boot"
require "invisible/mock"
require "spec"

Spec::Runner.configure do |config|
  config.prepend_before do
    @app = Invisible.new do
      root File.dirname(__FILE__) + "/.."
      load "config/env"
    end
  end
  config.include Invisible::MockMethods
end