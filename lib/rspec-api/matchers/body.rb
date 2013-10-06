RSpec::Matchers.define :be_a_json do |expected_type|
  match do |response_body|
    response_body.is_a? expected_type
  end

  description do
    "be a JSON #{expected_type}"
  end

  failure_message_for_should do |response|
    %q(should be a JSON #{expected_type}, but is #{response_body})
  end
end