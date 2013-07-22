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
end
