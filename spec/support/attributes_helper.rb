require 'spec_helper'
require 'rspec_api_documentation/dsl'

def has_attribute(name, type, options = {})
  (metadata[:attributes] ||= {})[name] = options.merge(type: type)
end

def assert_attributes(json)
  expect(json).to be_a (example.metadata[:array] ? Array : Hash)
  example.metadata[:attributes].each do |name, options|
    values = Array.wrap(json).map{|item| item[name.to_s]}
    values.compact! if options[:can_be_nil]
    expect(values.all? {|value| value.is_a? options[:type]}).to be_true
  end
end

def random_values_for_attributes
  {}.tap do |values|
    example.metadata[:attributes].each do |name, options|
      values[name] = case options[:type].to_s
        when 'String' then [*('a'..'z'), *('A'..'Z')].sample(Random.rand 32).join
        when 'Integer' then Random.rand(2**16)
      end
    end
  end
end