RSpec::Matchers.define :be_a_json do |expected_type|
  match do |json|
    json.is_a? expected_type
  end

  description do
    "be a JSON #{expected_type}"
  end

  failure_message_for_should do |json|
    %q(should #{description}, but is #{json})
  end
end