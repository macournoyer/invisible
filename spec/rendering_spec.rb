require File.dirname(__FILE__) + "/spec_helper"
require "invisible/rendering/erb"

describe Rendering do
  describe "text" do
    before do
      @app = Application.new do
        get do
          render "root"
        end
        
        get "/status" do
          render :nothing, :status => 201
        end
      end
    end
  
    it "should render text" do
      @app.mock.get("/").body.should == "root"
    end
  
    it "should default status to 200" do
      @app.mock.get("/").status.should == 200
    end

    it "should render with status code" do
      @app.mock.get("/status").status.should == 201
    end
  end
  
  describe "template" do
    before do
      @app = Application.new do
        get do
          @ivar = "there"
          render :template => "ohaie"
        end
        
        get "ohaie.js" do
          render :template => "ohaie"
        end
        
        get "ohaie"
        
        get ":id"
      end
    end
    
    it "should render .html.erb by default" do
      @app.mock.get("/").body.should == "ohaie in html there"
    end

    it "should render .js.erb when path ends with .js" do
      @app.mock.get("/ohaie.js").body.should == "ohaie in js"
    end
    
    it "should default to render template with name of path" do
      @app.mock.get("/ohaie").body.should == "ohaie in html "
    end
    
    it "should render default template with param in path" do
      @app.mock.get("/1").body.should == "this is id"
    end
  end
end