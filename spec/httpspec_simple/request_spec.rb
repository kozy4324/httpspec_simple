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

  describe "initialize with :timeout option" do
    it "should timeout within a specific time" do
      response = nil
      server_start( '/' => Proc.new {|req, res| sleep 2 } ) do
        response = HttpspecSimple::Request.new('http://localhost:10080/', :timeout => 1)
      end
      response.status.should == "timeout"
    end
  end

  it "should not retry a request by the default option" do
    response = nil
    requests = server_start( '/' => Proc.new {|req, res| res.status = "503" } ) do
      response = HttpspecSimple::Request.new('http://localhost:10080/')
    end
    requests.should have(1).items
    response.status.should == "503"
  end

  describe "initialize with :retry option" do
    context ":retry is 3, and the server will respond a status ok at 3rd time" do
      it "should retry requests while response is not ok" do
        response = nil
        response_codes = %w{503 404 200}
        requests = server_start( '/' => Proc.new {|req, res| res.status = response_codes.shift } ) do
          response = HttpspecSimple::Request.new('http://localhost:10080/', :retry => 3)
        end
        requests.should have(3).items
        response.status.should == "200"
      end
    end

    context ":retry is 3, and the server will not respond a status ok" do
      it "should retry requests 3 times" do
        response = nil
        response_codes = %w{503 500 404}
        requests = server_start( '/' => Proc.new {|req, res| res.status = response_codes.shift } ) do
          response = HttpspecSimple::Request.new('http://localhost:10080/', :retry => 3)
        end
        requests.should have(3).items
        response.status.should == "404"
      end
    end
  end
end
