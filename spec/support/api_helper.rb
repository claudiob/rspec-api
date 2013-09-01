require 'spec_helper'

shared_context 'accept_json', accepts: :json do
  before { header 'Accept', 'application/json' }
end

shared_context 'return_json', returns: :json do
  after { expect(json_response?) }
end

def json_response?
 last_response.headers['Content-Type'] == 'application/json; charset=utf-8'
end