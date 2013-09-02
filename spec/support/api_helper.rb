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
    assert_instances json
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

def json_response?
 response_headers['Content-Type'] == 'application/json; charset=utf-8'
end