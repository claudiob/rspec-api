require 'rspec-api/dsl/request/status'
require 'rspec-api/dsl/request/headers'
require 'rspec-api/dsl/request/body'

module DSL
  module Request
    extend ActiveSupport::Concern

    def response
      # To be overriden by more specific modules
      OpenStruct.new # body: nil, status: nil, headers: {}
    end

    def response_body
      JSON response.body
    rescue JSON::ParserError, JSON::GeneratorError
      nil
    end

    def response_headers
      response.headers || {}
    end

    def response_status
      response.status
    end

    def request_params
      {} # To be overriden by more specific modules
    end

    module ClassMethods
      def respond_with(status_symbol, &block)
        status_code = to_code status_symbol

        context 'responds with a status code that' do
          should_match_status_expectations(status_code)
        end
        context 'responds with headers that' do
          should_match_headers_expectations(status_code)
        end
        context 'responds with a body that' do
          should_match_body_expectations(status_code, &block)
        end
      end

    private

      def to_code(status_symbol)
        Rack::Utils.status_code status_symbol
      end

      def has_entity_body?(status_code)
        Rack::Utils::STATUS_WITH_NO_ENTITY_BODY.exclude? status_code
      end

      def success?(status_code)
        has_entity_body?(status_code) && status_code < 400
      end
    end
  end
end