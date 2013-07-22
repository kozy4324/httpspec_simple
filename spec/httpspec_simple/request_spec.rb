require 'spec_helper'

describe HttpspecSimple::Request do
  it "should request the url passed to 1st argument of constructor" do
    response = nil
    requests = server_start({
      "/" => Proc.new {|req, res| res.status = "200" }
    }) do
      response = HttpspecSimple::Request.new('http://localhost:10080/')
    end
    requests.should have(1).items
    requests.should include('http://localhost:10080/')
    response.status.should == "200"
  end
end
