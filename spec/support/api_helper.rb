# encoding: UTF-8
require 'spec_helper'
require 'rspec_api_documentation/dsl'

shared_context 'accept_json', accepts: :json do
  header 'Accept', 'application/json'
end

shared_context 'return_json', returns: :json do
  after { expect(json_response?) }
end

def request(description, request_params = {})
  default_request = {}
  example_requests = [default_request]

  if metadata[:array]
    if metadata[:filter_parameters]
      name = metadata[:filter_parameters][:name]
      filter_request = metadata[:filter_parameters].except(:name, :given, :block)
      filter_request[:description] = " filtered by #{name}"
      filter_request[:request_params] = {name => metadata[:filter_parameters][:given]}
      filter_request[:block] = metadata[:filter_parameters][:block]
      example_requests.push filter_request
    end
    if metadata[:sort_parameters]
      [true, false].each do |ascending|
        name = metadata[:sort_parameters][:name]
        sort_request = metadata[:sort_parameters].except(:name, :block)
        sort_request[:description] = " sorted by #{name} #{ascending ? '↑' : '↓'}"
        sort_request[:request_params] = {sort: "#{ascending ? '' : '-'}#{name}"}
        sort_request[:block] = metadata[:sort_parameters][:block]
        example_requests.push sort_request
      end
    end
  end

  example_requests.each do |request_metadata|
    (request_metadata[:description] ||= '').prepend description
    (request_metadata[:request_params] ||= {}).merge! request_params
    metadata.merge! request_metadata
    yield if block_given?
  end
end

def example_requests
  default_request = {}
  [default_request] + (metadata[:extra_requests] ||= [])
end

def request_params
  example.metadata[:request_params]
end

def respond_with(expected_status, &block)
  description = metadata[:description]
  example description do
    setup_instances
    evaluate_request_params!
    do_request request_params.dup
    assert_response expected_status, &example.metadata.fetch(:block, block)
  end
end

def assert_response(expected_status, &block)
  assert_status expected_status
  if block_given? || success? && returns_content?
    json = JSON response_body
    assert_attributes json if success?
    assert_instances json
    instance_exec(json, &block) if block_given?
  end
end

def evaluate_request_params!
  request_params.each do |name, value|
    request_params[name] = instance_exec(&value) if value.is_a? Proc
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