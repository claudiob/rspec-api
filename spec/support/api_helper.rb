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
    yield json
  end
end

def assert_status(expected_status)
  expect(status).to be expected_status
end

def json_response?
 response_headers['Content-Type'] == 'application/json; charset=utf-8'
end