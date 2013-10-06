RSpec::Matchers.define :be_filtered_by do |filtered_attribute, json_value=nil|
  match do |items|
    if filtered_attribute.nil?
      true
    else
      items.all?{|item| item[filtered_attribute.to_s].to_s == json_value}
    end
  end

  description do
    if filtered_attribute.nil?
      %Q(not be filtered by any specific attribute)
    else
      %Q(be filtered by #{filtered_attribute.to_json} => #{json_value})
    end
  end

  failure_message_for_should do |items|
    %Q(should #{description}, but is #{items})
  end
end