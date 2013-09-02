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