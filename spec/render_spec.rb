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
end

describe "render with layout" do
  before do
    @app = Invisible.new do
      layout do
        text "default>"
        text content
      end
      
      get "/text" do
        render "text"
      end
      
      get "/markaby" do
        render do
          text "markaby"
        end
      end
      
      get "/none" do
        render "none", :layout => :none
      end
      
      layout :named do
        text "named>"
        text content
      end
      
      get "/named" do
        render "named", :layout => :named
      end
    end
  end
  
  it "should render text inside default layout" do
    @app.mock.get("/text").body.should == "default>text"
  end

  it "should render markaby inside default layout" do
    @app.mock.get("/markaby").body.should == "default>markaby"
  end

  it "should render inside no layout" do
    @app.mock.get("/none").body.should == "none"
  end

  it "should render inside named layout" do
    @app.mock.get("/named").body.should == "named>named"
  end
end