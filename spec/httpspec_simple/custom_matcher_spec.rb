require 'spec_helper'

describe 'custom matchers' do
  describe '#be_http_ok' do
    it "should check status code" do
      response = nil
      server_start { response = request('/') }
      expect {
        response.should be_http_ok
      }.not_to raise_error
    end
  end

  describe '#respond_within(num).seconds' do
    it "should check response time" do
      response = nil
      server_start('/' => Proc.new {|req, res| sleep 2 }) do
        response = request('/')
      end
      response.should respond_within(3).seconds
      expect {
        response.should respond_within(1).seconds
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end
  end
end
