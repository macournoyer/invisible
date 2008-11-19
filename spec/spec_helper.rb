$:.unshift File.dirname(__FILE__) + "/../lib"
require 'invisible'
require 'invisible/mock'
require 'rubygems'
require 'spec'

include Invisible

module Helpers
end

class GetEnv
  def self.env
    @@env
  end

  def initialize(app)
    @app = app
  end

  def call(env)
    @@env = env
    @app.call(env)
  end
end

Spec::Runner.configure do |config|
  config.include Helpers
end