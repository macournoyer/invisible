require "rubygems"
require "invisible"
require "invisible/mock"
require "spec"

RACK_ENV = "test"

Spec::Runner.configure do |config|
  config.prepend_before do
    @app = Invisible.new do
      root File.dirname(__FILE__) + "/.."
      load "config/env"
    end
  end
  config.include Invisible::MockMethods
end