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

      get "/request" do
        render do
          text request.class.name
        end
      end
      
      get "/status" do
        render "", :status => 201
      end
      
      get "/anywhere" do
        render "anywhere"
        "ohnoz!"
      end
    end
  end
  
  it "should render text" do
    @app.mock.get("/text").body.should == "text"
  end

  it "should render markaby" do
    @app.mock.get("/markaby").body.should == "markaby"
  end
  
  it "should assign request inside markaby builder" do
    @app.mock.get("/request").body.should == "Rack::Request"
  end
  
  it "should use specified status" do
    @app.mock.get("/status").status.should == 201
  end
  
  it "should use default status to 200" do
    @app.mock.get("/text").status.should == 200
  end
  
  it "should allow render anywhere" do
    @app.mock.get("/anywhere").body.should == "anywhere"
  end
  
  it "should set Content-Length" do
    @app.mock.get("/text").headers["Content-Length"].should == "4"
  end

  it "should set Last-Modified" do
    @app.mock.get("/text").headers["Last-Modified"].should_not be_nil
  end
end
