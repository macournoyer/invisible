require File.dirname(__FILE__) + "/spec_helper"

describe "with" do
  before do
    @app = Invisible.new do
      with "/with" do
        get "/get" do
          render "get"
        end
        
        with "/double" do
          get "/again" do
            render "again"
          end
        end
      end
    end
  end
  
  it "should allow nesting with" do
    @app.mock.get("/with/get").body.should == "get"
  end

  it "should allow nesting multiple withs" do
    @app.mock.get("/with/double/again").body.should == "again"
  end
end
