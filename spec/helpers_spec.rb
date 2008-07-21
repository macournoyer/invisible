require File.dirname(__FILE__) + "/spec_helper"

describe "params" do
  before do
    @app = Invisible.new do
      helpers do
        def help_me
          "ok"
        end
      end
      
      get "/" do
        render help_me
      end
      
      get "/in-markaby" do
        render do
          text @helpers.help_me
        end
      end
    end
  end
  
  it "should include helpers in action" do
    @app.mock.get("/").body.should == "ok"
  end

  it "should include helpers in markaby" do
    @app.mock.get("/in-markaby").body.should == "ok"
  end
end