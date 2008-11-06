require File.dirname(__FILE__) + "/spec_helper"

describe "redirect" do
  before do
    @app = Invisible.new do
      get "/redirect" do
        redirect_to "/"
      end
    end
  end
  
  it "should redirect to path" do
    response = @app.mock.get("/redirect")
    response.status.should == 302
    response.body.should == "<p>You are redirected to <a href=\"/\">/</a></p>"
  end
end
