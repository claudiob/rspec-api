require 'spec_helper'

shared_context 'accept_json', accepts: :json do
  before { header 'Accept', 'application/json' }
end

shared_context 'return_json', returns: :json do
  after { expect(json_response?) }
end

def respond_with(expected_status)
  assert_status expected_status
  if block_given?
    json = JSON last_response.body
    yield json
  end
end

def assert_status(expected_status)
  expect(last_response.status).to be expected_status
end

def json_response?
 last_response.headers['Content-Type'] == 'application/json; charset=utf-8'
end