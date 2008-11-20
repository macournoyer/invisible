require File.dirname(__FILE__) + "/spec_helper"

describe Routing do
  before :all do
    @app = Application.new do
      get "/path" do
        render "/path"
      end

      get "/path.xml" do
        render "/path.xml"
      end

      get "/param/:name.xml" do
        render params[:name] + ".xml"
      end

      get "/param/:name" do
        render params[:name]
      end

      get "/param_with_underscore/:long_name" do
        render params[:long_name]
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

  it "should route and set param with underscore" do
    @app.mock.get("/param_with_underscore/ohaie").body.should == "ohaie"
  end

  it "should route /param/:param.xml" do
    @app.mock.get("/param/ohaie.xml").body.should == "ohaie.xml"
  end

  it "should route with no leading slash" do
    @app.mock.get("/no/slash").body.should == "no-slash"
  end

  it "should route ignore trailing slash" do
    @app.mock.get("/no/slash/").body.should == "no-slash"
  end
  
  describe "with nested resources" do
    before :all do
      @app = Application.new do
        resource "/some/:stuff" do
          get do
            render params[:stuff]
          end
          
          resource ":really" do
            get ":awesome" do
              render params.inspect
            end
          end
        end
      end
    end
    
    it "should route nested /some/:param" do
      @app.mock.get("/some/stuff").body.should == "stuff"
    end

    it "should route nested /some/:param/:really/:awesome" do
      @app.mock.get("/some/stuff/that/stinks").body.should == { :stuff => "stuff", :really => "that", :awesome => "stinks" }.inspect
    end
  end
end