require File.dirname(__FILE__) + "/spec_helper"
require "invisible/erb"

describe "erb" do
  before do
    @app = Invisible.new do
      get "/text" do
        @ohaie = "ivar"
        render erb("#{File.dirname(__FILE__)}/fixtures/ohaie")
      end
    end
  end
  
  it "should render erb template" do
    @app.mock.get("/text").body.should == "[ivar]"
  end
end
