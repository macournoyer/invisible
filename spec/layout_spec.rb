require File.dirname(__FILE__) + "/spec_helper"

describe "render with layout" do
  before do
    @app = Invisible.new do
      layout do
        text "markaby>"
        text @content
      end
      
      get "/text-in-markaby" do
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
        text @content
      end
      
      get "/named" do
        render "named", :layout => :named
      end
    end
  end
  
  it "should render text inside default markaby layout" do
    @app.mock.get("/text-in-markaby").body.should == "markaby>text"
  end

  it "should render markaby inside default markaby layout" do
    @app.mock.get("/markaby").body.should == "markaby>markaby"
  end

  it "should render inside no layout" do
    @app.mock.get("/none").body.should == "none"
  end

  it "should render inside named layout" do
    @app.mock.get("/named").body.should == "named>named"
  end
end