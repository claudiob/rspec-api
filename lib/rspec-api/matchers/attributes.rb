RSpec::Matchers.define :have_attribute do |name, options = {}|
  name, can_be_nil, type = name.to_s, options[:can_be_nil], options[:type]

  match do |json|
    Array.wrap(json).all? do |item|
      if (options[:parent_can_be_nil] and item.nil?) || (options[:parent_can_be_empty] and item.empty?)
        true
      elsif can_be_nil
        item.key?(name)
      else
        debugger unless matches_type?(item[name], type)
        matches_type?(item[name], type)
      end
    end
  end

  description do # TODO: add parent name
    type = "#{options[:type]}#{' or nil' if can_be_nil}"
    %Q(include the field #{name.to_json} of type #{type})
  end

  failure_message_for_should do |json|
    %Q(should #{description}, but is #{json})
  end
end

def matches_type?(value, type)
  case type
    when :url then value =~ URI::regexp
    when :timestamp then DateTime.iso8601 value rescue false
    when :boolean then [TrueClass, FalseClass].include? value.class
    else value.is_a? type.to_s.classify.constantize
  end
end