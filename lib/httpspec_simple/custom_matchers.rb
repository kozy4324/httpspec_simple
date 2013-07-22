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

  RSpec::Matchers.define :respond_within do |expected|
    match do |actual|
      actual.response_time < expected
    end

    failure_message_for_should do |actual|
      "expected: #{"%7.3f" % expected} seconds\n  result: #{"%7.3f" % actual.response_time} seconds"
    end

    define_method :seconds do
      self
    end
  end
end
