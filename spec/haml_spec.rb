require File.dirname(__FILE__) + "/spec_helper"
require "invisible/haml"

describe "haml" do
  before do
    @app = Invisible.new do
      root File.dirname(__FILE__) + "/fixtures"
      get "/text" do
        @ohaie = "ivar"
        render haml(:ohaie)
      end
    end
  end
  
  it "should render haml template" do
    @app.mock.get("/text").body.strip.should == "<h1>ivar</h1>"
  end
end
