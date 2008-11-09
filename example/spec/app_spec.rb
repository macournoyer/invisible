require File.dirname(__FILE__) + "/spec_helper"

describe "app" do
  it "should get /" do
    get("/").should be_ok
  end
  
  it "should set session on /session/stuff" do
    get("/session/stuff").should be_ok
    session[:invisible].should == "stuff"
  end

  it "should clear session on /session/clear" do
    get("/session/clear").should be_redirect
    session.should be_empty
  end
end