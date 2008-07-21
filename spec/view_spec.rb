require File.dirname(__FILE__) + "/spec_helper"

describe "view" do
  before do
    @app = Invisible.new do
      view :name do
        text "view"
      end
      
      get "/" do
        render :name
      end

      get "/missing" do
        render :missing
      end
    end
  end
  
  it "should render named view" do
    @app.mock.get("/").body.should == "view"
  end

  it "should render missing view" do
    @app.mock.get("/missing").body.should == ""
  end
end
