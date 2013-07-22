require 'spec_helper'

describe 'definition custom matchers' do
  it "should define the new matcher(not raise the error)" do
    response = nil
    server_start { response = request('/') }
    expect {
      response.should be_http_ok
    }.not_to raise_error
  end
end
