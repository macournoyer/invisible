require "rubygems"
require "invisible"
$:.unshift File.dirname(__FILE__) + "/../lib"

RACK_ENV = ENV["RACK_ENV"] ||= "development"