require File.dirname(__FILE__) + "/spec_helper"

describe "render" do
  before do
    @app = Invisible.new do
      get "/text" do
        render "text"
      end

      get "/markaby" do
        render do
          text "markaby"
        end
      end
    end
  end
  
  it "should render text" do
    @app.mock.get("/text").body.should == "text"
  end

  it "should render markaby" do
    @app.mock.get("/markaby").body.should == "markaby"
  end
end