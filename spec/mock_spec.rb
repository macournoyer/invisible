require File.dirname(__FILE__) + "/spec_helper"
require "invisible/mock"

describe "mock" do
  before do
    @app = Invisible.new do
      root File.dirname(__FILE__) + "/fixtures"
      get "/" do
        session[:ok] = true
      end
      
      get "/:param" do
      end
      
      use Rack::Session::Cookie
    end
  end
  
  include Invisible::MockMethods
  
  it "should add HTTP method helpers" do
    get("/").should be_ok
  end

  it "should add session helper" do
    get("/")
    session[:ok].should be_true
  end

  it "should add params helper" do
    get("/ok")
    params[:param].should == "ok"
  end
end
