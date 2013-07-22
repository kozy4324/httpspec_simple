require "httpspec_simple/version"
require "httpspec_simple/request"
require "httpspec_simple/custom_matchers"

RSpec.configure do |config|
  config.add_setting :base_url, :default => 'http://localhost:10080'
end

define_method "base_url" do |url|
  RSpec.configuration.base_url = url
end
define_method "request" do |path|
  HttpspecSimple::Request.new("#{RSpec.configuration.base_url}#{path}")
end
