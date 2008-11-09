require File.dirname(__FILE__) + "/boot"

RACK_ENV = ENV["RACK_ENV"] || "development"

Invisible.run do
  root File.dirname(__FILE__) + "/.."
  load "config/env"
end
