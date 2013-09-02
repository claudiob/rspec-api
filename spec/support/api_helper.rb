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
  if block_given?
    json = JSON response_body
    assert_attributes json if status < 400
    yield json
  end
end

def assert_status(expected_status)
  expect(status).to be expected_status
end

def has_attribute(name, type)
  (metadata[:attributes] ||= {})[name] = type
end

def assert_attributes(json)
  expect(json).to be_a (example.metadata[:array] ? Array : Hash)
  example.metadata[:attributes].each do |name, type|
    values = Array.wrap(json).map{|item| item[name.to_s]}
    expect(values.all? {|value| value.is_a? type}).to be_true
  end
end

def json_response?
 response_headers['Content-Type'] == 'application/json; charset=utf-8'
end