require File.dirname(__FILE__) + "/spec_helper"

describe Pipeline do
  class Cat
    def initialize(app, word="meow")
      @app = app
      @word = word
    end
    
    def call(env)
      env["cat"] = @word
      @app.call(env)
    end
  end
  
  before do
    @pipeline = Pipeline.new
    @app = proc { |env| Response.new.finish }
  end
  
  it "should register middleware" do
    @pipeline.use Cat, "meow"
    
    middleware = @pipeline.middlewares.first
    middleware.klass.should == Cat
    middleware.args.should == ["meow"]
    middleware.block.should == nil
  end
  
  it "should apply middlewares in reverse order" do
    @pipeline.use Rack::Lint
    @pipeline.use Rack::CommonLogger
    
    @pipeline.apply(@app).should be_kind_of(Rack::Lint)
  end
  
  it "should apply middleware to app" do
    @pipeline.use Cat
    
    env = {}
    @pipeline.apply(@app).call(env)
    env.should have_key("cat")
  end
  
  it "should merge pipelines" do
    other_pipeline = Pipeline.new
    other_pipeline.use Rack::Lint
    @pipeline.use Cat
    
    @pipeline.merge(other_pipeline).size.should == 2
  end
end