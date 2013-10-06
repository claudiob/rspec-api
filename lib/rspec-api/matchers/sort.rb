RSpec::Matchers.define :be_sorted_by do |sorting_field, options = {}|
  match do |items|
    if sorting_field.nil?
      true
    else
      values = items.map{|item| item[sorting_field.to_s]}
      values.reverse! if options[:verse] == :desc
      values == values.sort
    end
  end

  description do
    # NOTE: Since `accepts_sort random: nil` is acceptable, this description
    # should say "you should not expect any sorting by any specific field"
    if sorting_field.nil?
      %Q(not be sorted by any specific attribute)
    else
      %Q(be sorted by #{sorting_field.to_json} #{options[:verse]})
    end
  end

  failure_message_for_should do |items|
    %Q(should #{description}, but is #{items})
  end
end