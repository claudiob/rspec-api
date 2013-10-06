require 'rspec-api/matchers'

module DSL
  module Request
    extend ActiveSupport::Concern

    module ClassMethods
      def should_match_headers_expectations(status_code)
        should_have_json_content_type if has_entity_body? status_code
        should_be_paginated(rspec_api[:page]) if rspec_api[:array] # find a better name
      end

    private

      def should_have_json_content_type
        it { expect(response_headers).to have_json_content_type }
      end

      def should_be_paginated(page_parameter)
        it { expect(response_headers).to have_pagination_links(request_params[page_parameter.to_s]) }
      end
    end
  end
end