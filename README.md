# HttpspecSimple

RSpec extension for HTTP request

## Usage

```
require 'httpspec_simple'

base_url 'http://kozy4324.github.io'

describe request('/') do
  it { should be_http_ok }
  it { should respond_within(2).seconds }
  it { should retrieve_body_including '<title>L4L</title>' }
end

describe request('/blog/archives/') do
  it { should be_http_ok }
  it { should respond_within(2).seconds }
  it { should retrieve_body_including '<title>Blog Archive - L4L</title>' }
end
```

```
$ rspec -f d

http://kozy4324.github.io/
  should be http ok
  should respond within 2 seconds (got 0.122 seconds)
  should retrieve body including "<title>L4L</title>"

http://kozy4324.github.io/blog/archives/
  should be http ok
  should respond within 2 seconds (got 0.111 seconds)
  should retrieve body including "<title>Blog Archive - L4L</title>"
```

## Custom matchers

### be_http_ok

Example passes if response is 200 ok

### resond_within(n).seconds

Example passes if response time is less than n seconds

### retrieve_body_including(string)

Example passes if response body include the passed string

### retrieve_body_matching(regexp)

Example passes if response body match the passed regexp

## helper method

### request(url, opt={})

Do request

option key | type    | description
---------- | ------- | -----------
:retry     | integer | when the response code is {40x,50x} or the timeout occurs, retry request the specific times, default value is 0
:timeout   | integer | set to Net::HTTP's open_timeout and read_timeout

### base_url(prepend_string)

Prepend to the url string passed to following `request` method

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
