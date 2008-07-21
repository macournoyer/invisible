require File.dirname(__FILE__) + "/spec_helper"

describe "params" do
  before do
    @app = Invisible.new do
      get "/" do
        render params.inspect
      end
      get "/:path" do
        render params.inspect
      end
    end
  end
  
  it "should include request params" do
    @app.mock.get("/?oh=aie").body.should == { 'oh' => 'aie' }.inspect
  end

  it "should include path params" do
    @app.mock.get("/oh").body.should == { 'path' => 'oh' }.inspect
  end
end