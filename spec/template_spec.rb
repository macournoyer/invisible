require File.dirname(__FILE__) + "/spec_helper"
require "invisible/rendering/erb"

describe Template do
  ERB_TEMPLATE = File.dirname(__FILE__) + "/fixtures/views/ohaie.html.erb"
  
  it "should extract engine from last ext" do
    Template.new("ohaie.html.erb", "html").engine.should == "erb"
  end
  
  it "should render erb" do
    @ivar = "ivar"
    Template.new(ERB_TEMPLATE, "html").render(self).should == "ohaie in html ivar"
  end
  
  it "should raise when rendering with no associated engine" do
    proc { Template.new("ohaie.html.poop", "html").render(self) }.should raise_error(Template::NoEngine)
  end
end

describe Template::Locator do
  before do
    @locator = Template::Locator.new([File.dirname(__FILE__) + "/fixtures/views"])
  end
  
  it "should locate html template" do
    @locator.locate("ohaie", "html").path.should == File.dirname(__FILE__) + "/fixtures/views/ohaie.html.erb"
  end

  it "should locate js template" do
    @locator.locate("ohaie", "js").path.should == File.dirname(__FILE__) + "/fixtures/views/ohaie.js.erb"
  end

  it "should raise when can't locate template" do
    proc { @locator.locate("ohaie", "xml") }.should raise_error(Template::NotFound)
  end
end
