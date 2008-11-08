require "rubygems"
require "invisible"

RACK_ENV = ENV["RACK_ENV"] || "development"

Invisible.run do
  root File.dirname(__FILE__) + "/.."
  load "config/env"
end
