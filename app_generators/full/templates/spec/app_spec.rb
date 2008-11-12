require File.dirname(__FILE__) + "/spec_helper"

describe "app" do
  it "should get /" do
    get("/").should be_ok
  end
end