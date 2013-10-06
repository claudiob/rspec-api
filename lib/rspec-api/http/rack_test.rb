require 'rack/test'

def app
  Rails.application
end

module DSL
  module RackTest
    module Route
      extend ActiveSupport::Concern

      def send_request(verb, route, body)
        header 'Accept', 'application/json'
        send verb, route, body
      end
    end
  end
end


module DSL
  module RackTest
    module Request
      extend ActiveSupport::Concern

      def response
        last_response
      end

      def request_params
        last_request.params
      end
    end
  end
end


RSpec.configuration.include Rack::Test::Methods, rspec_api_dsl: :route
RSpec.configuration.include DSL::RackTest::Route, rspec_api_dsl: :route
RSpec.configuration.include DSL::RackTest::Request, rspec_api_dsl: :request
