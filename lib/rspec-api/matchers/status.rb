RSpec::Matchers.define :be_status do |expected|
  match do |actual|
    actual == expected
  end

  description do
    %Q(be #{expected})
  end

  failure_message_for_should do |actual|
    %Q(should #{description}, but is #{actual})
  end
end