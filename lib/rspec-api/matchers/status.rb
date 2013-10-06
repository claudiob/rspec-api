RSpec::Matchers.define :be_status do |expected|
  match do |actual|
    actual == expected
  end

  description do
    "be #{expected}"
  end

  failure_message_for_should do |response|
    %Q(should be #{expected}, but is #{actual})
  end
end