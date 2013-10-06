RSpec::Matchers.define :include_fixture_data do
  match do |body|
    if body.empty? #&& did_not_declare_fixtures
      pending 'Make your tests more meaningful by declaring fixtures!'
    end
    !body.empty?
  end

  description do
    "have some values from the fixtures"
  end

  failure_message_for_should do |response|
    "expected values from fixtures, but got an empty array"
  end
end