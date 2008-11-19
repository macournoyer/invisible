require File.dirname(__FILE__) + "/../spec_helper"

describe Middleware::ContentLength do
  before do
    @app = Application.new do
      resource "context" do
        before { @c = self }
        get    { render @c == self }
      end

      resource "ivar" do
        before { @ivar = "meow" }
        get    { render @ivar }
      end
      
      resource "request_response" do
        before do
          request.path_info
          response.headers
        end
        get { }
      end
    end
  end
  
  it "should share same instance" do
    @app.mock.get("/context").body.should == "true"
  end
  
  it "should share instance variables" do
    @app.mock.get("/ivar").body.should == "meow"
  end

  it "should be able to access request and response" do
    @app.mock.get("/request_response").should be_ok
  end
end