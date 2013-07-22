require 'spec_helper'

describe 'definition custom matchers' do
  it "should define the new matcher(not raise the error)" do
    expect {
      Struct.new("DummyRequest", :status).new("200").should be_http_ok
    }.not_to raise_error
  end
end
