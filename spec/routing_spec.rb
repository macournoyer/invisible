require File.dirname(__FILE__) + "/spec_helper"

describe "routing" do
  before do
    @app = Invisible.new do
      get "/path" do
        render "/path"
      end
      
      get "/path.xml" do
        render "/path.xml"
      end
      
      get "/param/:name" do
        render params[:name]
      end
      
      get "no/slash" do
        render "no-slash"
      end
      
      get "/" do
        render "get"
      end
      
      post "/" do
        render "post"
      end
      
      delete "/" do
        render "delete"
      end
    end
  end
  
  it "should route GET /" do
    @app.mock.get("/").body.should == "get"
  end
  
  it "should route POST /" do
    @app.mock.post("/").body.should == "post"
  end
  
  it "should route DELETE /" do
    @app.mock.delete("/").body.should == "delete"
  end
  
  it "should route DELETE with _method hack" do
    @app.mock.post("/", :input => "_method=DELETE").body.should == "delete"
  end
  
  it "should not route DELETE with _method hack on GET" do
    @app.mock.get("/?_method=DELETE").body.should_not == "delete"
  end
  
  it "should return 404 when no route" do
    @app.mock.get("/no-route").status.should == 404
  end
  
  it "should route /path" do
    @app.mock.get("/path").body.should == "/path"
  end
  
  it "should route /path.xml" do
    @app.mock.get("/path.xml").body.should == "/path.xml"
  end
  
  it "should route /param/:param" do
    @app.mock.get("/param/ohaie").body.should == "ohaie"
  end
  
  it "should route with no leading slash" do
    @app.mock.get("/no/slash").body.should == "no-slash"
  end
  
  it "should route ignore trailing slash" do
    @app.mock.get("/no/slash/").body.should == "no-slash"
  end
end