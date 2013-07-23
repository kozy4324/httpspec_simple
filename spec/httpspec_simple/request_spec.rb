require 'spec_helper'

describe HttpspecSimple::Request do
  it "should request the url passed to 1st argument of constructor" do
    response = nil
    requests = server_start do
      response = HttpspecSimple::Request.new('http://localhost:10080/')
    end
    requests.should have(1).items
    requests.should include('http://localhost:10080/')
    response.status.should == "200"
  end

  it "should timeout within a specific time" do
    response = nil
    server_start( '/' => Proc.new {|req, res| sleep 2 } ) do
      response = HttpspecSimple::Request.new('http://localhost:10080/', :timeout => 1)
    end
    response.status.should == "timeout"
  end
end
