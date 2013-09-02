require 'spec_helper'
require 'rspec_api_documentation/dsl'

shared_context 'accept_json', accepts: :json do
  header 'Accept', 'application/json'
end

shared_context 'return_json', returns: :json do
  after { expect(json_response?) }
end

def respond_with(expected_status)
  assert_status expected_status
  if block_given? || success? && returns_content?
    json = JSON response_body
    assert_attributes json if success?
    yield json if block_given?
  end
end

def success?
  status < 400
end

def returns_content?
  [100, 101, 102, 204, 205, 304].exclude? status
end

def assert_status(expected_status)
  expect(status).to be Rack::Utils.status_code(expected_status)
end

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

def json_response?
 response_headers['Content-Type'] == 'application/json; charset=utf-8'
end