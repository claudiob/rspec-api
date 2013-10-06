RSpec::Matchers.define :have_field do |key, options = {}|
  value = options[:value]

  match do |item|
    item[key.to_s] == value
  end

  description do
    %Q(have the value #{value.to_json} in the field #{key})
  end

  failure_message_for_should do |item|
    %Q(should have the value #{value.to_json} in the field #{key}, but got #{item})
  end
end

RSpec::Matchers.define :have_fields do |key, options = {}|
  value = options[:value]
  after = options[:after]

  match do |items|
    items.all?{|item| item[key.to_s].send(after) == value }
  end

  description do
    %Q(have the value #{value.to_json} in the field #{key} after #{after})
  end

  failure_message_for_should do |items|
    %Q(should have the value #{value.to_json} in the field #{key} after #{after}, but got #{items})
  end
end