require File.dirname(__FILE__) + "/spec_helper"

describe "REST" do
  before do
    @app = Invisible.new do
      get "/" do
        render "get it?"
      end
      
      post "/" do
        render "post it?"
      end

      put "/" do
        render "put it?"
      end

      delete "/" do
        render "delete it?"
      end
    end
  end
  
  it "should respond to GET /" do
    @app.mock.get("/").body.should == "get it?"
  end

  it "should respond to POST /" do
    @app.mock.post("/").body.should == "post it?"
  end

  it "should respond to PUT /" do
    @app.mock.put("/").body.should == "put it?"
  end

  it "should respond to DELETE /" do
    @app.mock.delete("/").body.should == "delete it?"
  end
  
  it "should use _method request param" do
    @app.mock.post("/?_method=put").body.should == "put it?"
  end

  it "should use _method form param" do
    @app.mock.post("/", :input => "_method=put").body.should == "put it?"
  end
end