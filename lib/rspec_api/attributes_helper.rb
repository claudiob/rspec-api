require 'spec_helper'
require 'rspec_api_documentation/dsl'

def has_attribute(name, type, options = {})
  (metadata[:attributes] ||= {})[name] = options.merge(type: type)
end

def assert_attributes(json)
  expect(json).to be_a (example.metadata[:array] ? Array : Hash)
  example.metadata[:attributes].each do |name, options|
    values = Array.wrap(json).map{|item| item[name.to_s]}
    assert_attribute_types(values, options[:type], options[:can_be_nil])
  end
end

def random_values_for_attributes
  {}.tap do |values|
    example.metadata[:attributes].each do |name, options|
      can_be_nil = options[:can_be_nil] && (name != example.metadata[:on])
      values[name] = random_attribute_value options.merge(can_be_nil: can_be_nil)
    end
  end
end

def random_attribute_value(options)
  if options[:can_be_nil] && [true, false].sample
    nil
  else
    case options[:type]
      when :string then [*('a'..'z'), *('A'..'Z')].sample(Random.rand 32).join
      when :integer then Random.rand(2**16)
      when :url then "http://example.com/#{SecureRandom.urlsafe_base64}"
    end
  end
end

def assert_attribute_types(values, expected_type, can_be_nil)
  values.compact! if can_be_nil
  expect(values.all? {|value| matches_type? value, expected_type}).to be_true
end

def matches_type?(value, type)
  case type
    when :url then value =~ URI::regexp
    else value.is_a? type.to_s.classify.constantize
  end
end