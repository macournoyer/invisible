require File.dirname(__FILE__) + "/spec_helper"

describe "params" do
  before do
    @app = Invisible.new do
      def help_me
        "ok"
      end
      
      get "/" do
        render help_me
      end
      
      get "/in-markaby" do
        render do
          help_me
        end
      end
    end
  end
  
  it "should include helpers in action" do
    @app.should respond_to(:help_me)
    @app.mock.get("/").body.should == "ok"
  end

  it "should include helpers in markaby" do
    @app.mock.get("/in-markaby").body.should == "ok"
  end
  
  it "should not add helper methods to all apps" do
    app = Invisible.new
    app.should_not respond_to(:help_me)
  end
end