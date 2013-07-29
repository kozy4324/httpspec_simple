module HttpspecSimple
  RSpec::Matchers.define :be_http_ok do
    match do |actual|
      actual.status == '200'
    end

    failure_message_for_should do |actual|
      "expected: 200\n     got: #{actual.status}"
    end

    failure_message_for_should_not do |actual|
      "#{actual.to_s} would not be http ok"
    end
  end

  RSpec::Matchers.define :be_http_redirect do
    match do |actual|
      actual.status == '301' || actual.status == '302'
    end

    failure_message_for_should do |actual|
      "expected: 301 or 302\n     got: #{actual.status}"
    end

    failure_message_for_should_not do |actual|
      "#{actual.to_s} would not be http redirect"
    end
  end

  RSpec::Matchers.define :respond_within do |expected|
    match do |actual|
      (@response_time = actual.response_time) < expected
    end

    failure_message_for_should do |actual|
      "expected: #{"%7.3f" % expected} seconds\n  result: #{"%7.3f" % actual.response_time} seconds"
    end

    define_method :seconds do
      self
    end

    define_method :description do
      "respond within #{expected} seconds (got %.3f seconds)" % @response_time
    end
  end

  RSpec::Matchers.define :retrieve_body_including do |expected|
    match do |actual|
      actual.body.include?(expected)
    end

    failure_message_for_should do |actual|
      "expected the body to include \"#{expected}\""
    end
  end

  RSpec::Matchers.define :retrieve_body_matching do |expected|
    match do |actual|
      matchdata = actual.body.match(expected)
      @captures = matchdata.captures if matchdata
      !matchdata.nil?
    end

    failure_message_for_should do |actual|
      "expected the body to match \"#{expected}\""
    end

    define_method :description do
      if @captures
        messages = []
        @captures.each_with_index {|capture, index| messages.push("#{index} => \"#{capture}\"")}
        "retrieve body matching /#{expected}/ {#{messages.join(" ")}}"
      else
        "retrieve body matching /#{expected}/"
      end
    end
  end
end
