module DSL
  module Route
    extend ActiveSupport::Concern

    def send_request(verb, route, body)
      # To be overriden by more specific modules
    end

    module ClassMethods
      def request(text, values = {}, &block)
        # NOTE: setup_fixtures *might* go before the context if all the
        # cases have the same fixtures. But that might not *always* be: for
        # instance the same index action with two different filters might
        # require different fixtures. If that happens, move setup_fixtures
        # back inside each context
        setup_fixtures
        extra_parameters.each do |params|
          request_with_extra_params text, values.merge(params), &block
        end
      end

      def setup_fixtures
        # To be overriden by more specific modules
      end

    private

      def request_with_extra_params(text, values = {}, &block)
        context request_description(text, values), rspec_api_dsl: :request do
          setup_request rspec_api[:verb], rspec_api[:route], values
          instance_eval(&block) if block_given?
        end
      end

      def extra_parameters
        [].tap do |optional_params|
          optional_params << {} # default: no extra params
          optional_params << {page: 2} if rspec_api[:page] && rspec_api[:array]
        end
      end

      def setup_request(verb, route, values)
        request = Proc.new {
          interpolated_route, body = route.dup, values.dup
          body.keys.each do |key|
            if interpolated_route[":#{key}"]
              value = body.delete(key)
              value = value.call if value.is_a?(Proc)
              interpolated_route[":#{key}"] = value.to_s
              (@request_params ||= {})[key] = value
            end
          end
          [interpolated_route, body]
        }
        before(:all) { send_request verb, *instance_eval(&request) }
      end

      def request_description(text, values)
        if values.empty?
          'by default'
        else
          text = "with" if text.empty?
          "#{text} #{values.map{|k,v| "#{k}#{" #{v}" unless v.is_a?(Proc)}"}.to_sentence}"
        end
      end
    end
  end
end