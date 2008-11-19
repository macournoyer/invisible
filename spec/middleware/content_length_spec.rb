require File.dirname(__FILE__) + "/../spec_helper"

describe Middleware::ContentLength do
  before do
    @app = Application.new do
      get do
        render "ohaie"
      end
      
      use Middleware::ContentLength
    end
  end

  it "should set Content-Length" do
    @app.mock.get("/").headers["Content-Length"].should_not be_nil
  end
end