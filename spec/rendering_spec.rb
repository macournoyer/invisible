require File.dirname(__FILE__) + "/spec_helper"

describe Resource do
  before do
    @app = Application.new do
      get do
        render "root"
      end

      get "options" do
        $env = request.env
        render "options", :some => "option"
      end
      
      use GetEnv
    end
  end
  
  it "should render text" do
    @app.mock.get("/").body.should == "root"
  end
  
  it "should set render options in request env" do
    @app.mock.get("/options")
    GetEnv.env["invisible.render_options"].should == { :some => "option" }
  end
end