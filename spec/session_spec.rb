require File.dirname(__FILE__) + "/spec_helper"

describe "session" do
  before do
    @app = Invisible.new do
      put "/:value" do
        session[:param] = params[:value]
        render "ok"
      end
      
      get "/" do
        render session[:param]
      end
      
      use Rack::Session::Cookie
    end
  end
  
  it "should store session" do
    response = @app.mock.put("/cat")
    response.should be_ok
    response.headers["Set-Cookie"].should_not be_nil
  end

  it "should retreive session" do
    response = @app.mock.get("/", "HTTP_COOKIE" => @app.mock.put("/cat").headers["Set-Cookie"])
    response.body.should == "cat"
  end
end