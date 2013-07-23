# HttpspecSimple

RSpec extension for HTTP request

## Usage

```
require 'httpspec_simple'

base_url 'http://kozy4324.github.io'

describe request('/') do
  it { should be_http_ok }
  it { should respond_within(2).seconds }
end

describe request('/blog/archives/') do
  it { should be_http_ok }
  it { should respond_within(2).seconds }
end
```

## Custom matchers

### be_http_ok

Example passes if response is 200 ok

### resond_within(n).seconds

Example passes if response time is less than n seconds

## helper method

### request(url)

Do request

### base_url(prepend_string)

Prepend to the url string passed to following `request` method

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
