require File.dirname(__FILE__) + "/../spec_helper"

describe Middleware::NormalizeBody do
  before do
    @app = Application.new do
      get "array" do
        render %w(ohaie)
      end

      get "string" do
        render "ohaie"
      end
      
      use Middleware::NormalizeBody
    end
  end

  it "should normalize array body" do
    @app.mock.get("/array").body.should == "ohaie"
  end

  it "should normalize string body" do
    @app.mock.get("/string").body.should == "ohaie"
  end
end