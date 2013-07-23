require "httpspec_simple/version"
require "httpspec_simple/request"
require "httpspec_simple/custom_matchers"

RSpec.configure do |config|
  config.add_setting :base_url, :default => 'http://localhost:10080'
end

def base_url url
  RSpec.configuration.base_url = url
end
def request path, opt={}
  HttpspecSimple::Request.new("#{RSpec.configuration.base_url}#{path}", opt)
end
