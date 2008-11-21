require File.dirname(__FILE__) + "/spec_helper"

describe Request do
  it "should return html as default format" do
    Request.new("PATH_INFO" => "/ohaie").format.should == "html"
  end

  it "should return format" do
    Request.new("PATH_INFO" => "/ohaie.xml").format.should == "xml"
  end
end