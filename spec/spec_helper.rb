$:.unshift File.dirname(__FILE__) + "/../lib"
require 'invisible'
require 'invisible/mock'
require 'rubygems'
require 'spec'
require 'pp'

include Invisible

module Helpers
end

Spec::Runner.configure do |config|
  config.include Helpers
end