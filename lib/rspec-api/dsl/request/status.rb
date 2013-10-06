require 'rspec-api/matchers'

module DSL
  module Request
    extend ActiveSupport::Concern

    module ClassMethods
      def should_match_status_expectations(status_code)
        it { expect(response_status).to be_status status_code }
      end
    end
  end
end