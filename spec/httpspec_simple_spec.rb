require 'spec_helper'

describe "RSpec configuration" do
  describe "#base_url" do
    it "should be callable" do
      expect {
        base_url 'http://www.example.com'
      }.not_to raise_error
    end
  end
  describe "#request" do
    it "should be callable" do
      expect {
        server_start { request '/' }
      }.not_to raise_error
    end
  end
end
