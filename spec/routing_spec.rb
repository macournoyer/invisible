require File.dirname(__FILE__) + "/spec_helper"

describe "routing" do
  before do
    @app = Invisible.new do
      get "/path" do
        render "/path"
      end
      
      get "/param/:name" do
        render params[:name]
      end
      
      get "/" do
        render "/"
      end
      
      get "no/slash" do
        render "no-slash"
      end
    end
  end
  
  it "should route /" do
    @app.mock.get("/").body.should == "/"
  end

  it "should return 404 when no route" do
    @app.mock.get("/no-route").status == 404
  end

  it "should route /path" do
    @app.mock.get("/path").body.should == "/path"
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