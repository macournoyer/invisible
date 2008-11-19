require File.dirname(__FILE__) + "/spec_helper"

describe Context do
  before do
    @context = Context.create("/") do
      get {}
      post {}
      put {}
      delete {}
    end
  end
  
  it "should be a subclass of Context" do
    @context.superclass.should == Context
  end

  describe "actions" do
    it "should be added" do
      @context.should have(4).actions
    end

    it "should be stored per method" do
      @context.actions.keys.should include("GET", "POST", "PUT", "DELETE")
    end

    it "should be instance of Context" do
      @context.actions["GET"].should be_kind_of(@context)
    end
  end
  
  describe "resources" do
    before do
      @context = Context.create("/") do
        get "s" do; end
        get "very_long" do; end
        
        resource "//path" do
          get {}
        end
      end
    end
    
    it "should be added" do
      @context.should have(3).resources
    end
    
    it "should normalize path" do
      @context.resources.map { |r| r.path }.should include("/very_long", "/path", "/s")
    end
    
    it "should be sorted per path length" do
      @context.resources.first.path.should == "/very_long"
      @context.resources.last.path.should == "/s"
    end
  end
end