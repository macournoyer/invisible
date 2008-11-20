require File.dirname(__FILE__) + "/spec_helper"

describe Resource do
  before :all do
    @app = Application.new do
      get do
        render "root"
      end
      
      get "first" do
        render "root/first"
      end
      
      resource "second" do
        get do
          render "root/second"
        end

        get "third" do
          render "root/second/third"
        end
      end
    end
  end
  
  it "should add action to root resource" do
    @app.mock.get("/").body.should == "root"
  end

  it "should create implicit resource when specifiying path" do
    @app.mock.get("/first").body.should == "root/first"
  end

  it "should create explicit resource" do
    @app.mock.get("/second").body.should == "root/second"
  end

  it "should create implicit resource in nested resource" do
    @app.mock.get("/second/third").body.should == "root/second/third"
  end
end