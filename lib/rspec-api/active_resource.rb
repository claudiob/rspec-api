require 'faraday'

module DSL
  module ActiveResource
    module Route
      extend ActiveSupport::Concern

      def send_request(verb, route, body)
        conn = Faraday.new 'https://api.github.com/' do |c|
          c.use Faraday::Response::Logger, Logger.new('log/faraday.log')
          c.use Faraday::Adapter::NetHttp
        end

        conn.headers[:user_agent] = 'RSpec API for Github'
        conn.authorization *authorization.flatten

        @last_response = conn.send verb, route, (body.to_json if body.present?)
      end

      def authorization
        # TODO: Any other way to access metadata in a before(:all) ?
        self.class.metadata[:rspec_api][:authorization]
      end

      module ClassMethods

        def setup_fixtures
          # nothing to do for now...
        end

        def existing(field)
          case field
          when :user then 'claudiob'
          when :gist_id then '0d7b597d822102148810'
          when :id then '921225'
          end
        end

        def unknown(field)
          case field
          when :user then 'not-a-valid-user'
          when :gist_id then 'not-a-valid-gist-id'
          when :id then 'not-a-valid-id'
          end
        end
      end
    end
  end
end


module DSL
  module ActiveResource
    module Resource
      extend ActiveSupport::Concern

      module ClassMethods
        def authorize_with(options = {})
          rspec_api[:authorization] = options
        end
      end
    end
  end
end


module DSL
  module ActiveResource
    module Request
      extend ActiveSupport::Concern

      def response
        @last_response
      end

      def request_params
        # TO DO
      end
    end
  end
end

RSpec.configuration.include DSL::ActiveResource::Resource, rspec_api_dsl: :resource
RSpec.configuration.include DSL::ActiveResource::Request, rspec_api_dsl: :request
RSpec.configuration.include DSL::ActiveResource::Route, rspec_api_dsl: :route