require File.dirname(__FILE__) + "/spec_helper"
require "invisible/erubis"

describe "erubis" do
  before do
    @app = Invisible.new do
      root File.dirname(__FILE__) + "/fixtures"
      get "/text" do
        @ohaie = "ivar"
        render erb(:ohaie)
      end
    end
  end
  
  it "should render erubis template" do
    @app.mock.get("/text").body.should == "[ivar]"
  end
end
