require 'rubygems'
require 'invisible'
require 'invisible/mock'
require 'spec'

describe "app" do
  before do
    @app = Invisible.new do
      root File.dirname(__FILE__) + "/.."
      load "config/env/test"
      load "app"
    end
  end
  
  it "should get /" do
    @app.mock.get("/").should be_ok
  end
end