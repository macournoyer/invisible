require File.dirname(__FILE__) + "/boot"

Invisible.run do
  root File.dirname(__FILE__) + "/.."
  load "config/env"
end
