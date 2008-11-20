require File.dirname(__FILE__) + "/spec_helper"

describe Rendering do
  before do
    @app = Application.new do
      get do
        render "root"
      end
      
      get "/status" do
        render "", :status => 201
      end
    end
  end
  
  it "should render text" do
    @app.mock.get("/").body.should == "root"
  end
  
  it "should default status to 200" do
    @app.mock.get("/").status.should == 200
  end

  it "should render with status code" do
    @app.mock.get("/status").status.should == 201
  end
end