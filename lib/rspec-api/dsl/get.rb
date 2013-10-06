module DSL
  module Route
    extend ActiveSupport::Concern

    def send_request(verb, route, body)
      # To be overriden by more specific modules
    end

    module ClassMethods
      def request(*args, &block)
        text, values = parse_request_arguments args
        extra_parameters.each do |params|
          request_with_extra_params text, values.merge(params), &block
        end
      end

      def setup_fixtures
        # To be overriden by more specific modules
      end

      def existing(field)
        # To be overriden by more specific modules
      end

    private

      def request_with_extra_params(text, values = {}, &block)
        context request_description(text, values), rspec_api_dsl: :request do
          # NOTE: Having setup_fixtures inside the context sets up different
          # fixtures for each `request` inside the same `get`. This might be
          # a little slower on the DB, but ensures that two `request`s do not
          # conflict. For instance, if you have two `request` inside a `delete`
          # and the first deletes an instance, the second `request` is no
          # affected.
          setup_fixtures
          setup_request rspec_api[:verb], rspec_api[:route], values
          instance_eval(&block) if block_given?
        end
      end

      def extra_parameters
        [].tap do |optional_params|
          optional_params << {} # default: no extra params
          if rspec_api[:array]
            if rspec_api[:sort]
              optional_params << {sort: rspec_api[:sort][:parameter]}
              optional_params << {sort: "-#{rspec_api[:sort][:parameter]}"}
            end
            if rspec_api[:page]
              optional_params << {page: 2}
            end
            if rspec_api[:filter]
              optional_params << {rspec_api[:filter][:parameter] => existing(rspec_api[:filter][:attribute])}
            end
          end
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
            else
              body[key] = body[key].call if body[key].is_a?(Proc)
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
          text = "with" unless text.present?
          "#{text} #{values.map{|k,v| "#{k}#{" #{v}" unless v.is_a?(Proc)}"}.to_sentence}"
        end
      end

      def parse_request_arguments(args)
        text = args.first.is_a?(String) ? args.first : ''
        values = args.first.is_a?(String) ? args.second : args.first
        [text, values || {}] # NOTE: In Ruby 2.0 we could write values.to_h
      end
    end
  end
end