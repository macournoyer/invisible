require File.dirname(__FILE__) + "/spec_helper"

class FunkyMiddleware
  def initialize(app)
    @app = app
  end
  def call(env)
    env["X_FUNKY"] = "Get up!"
    @app.call(env)
  end
end

describe "middleware" do
  before do
    @app = Invisible.new do
      get "/" do
        render request.env["X_FUNKY"]
      end
      
      use FunkyMiddleware
    end
  end
  
  it "should call middleware" do
    @app.mock.get("/").body.should == "Get up!"
  end

  it "should call middleware (using Invisible\#call)" do
    Rack::MockRequest.new(@app).get("/").body.should == "Get up!"
  end
end