require 'rspec-api/matchers'

module DSL
  module Request
    extend ActiveSupport::Concern

    module ClassMethods
      def should_match_body_expectations(status_code, &block)
        should_return_a_json rspec_api[:array] if success? status_code
        should_include_attributes rspec_api.fetch(:attributes, {}) if success? status_code
        should_include_fixture_data if rspec_api[:array] && !rspec_api[:page]
        should_be_sorted_by(rspec_api[:sort]) if rspec_api[:array] && rspec_api[:sort]
        should_satisfy_expectations_in &block if block_given?
      end

    private

      def should_return_a_json(is_array)
        it { expect(response_body).to be_a_json(is_array ? Array : Hash) }
      end

      def should_include_fixture_data
        it { expect(response_body).to include_fixture_data }
      end

      def should_be_sorted_by(sort_options)
        it {
          if sort_options[:parameter].to_s == request_params['sort']
            expect(response_body).to be_sorted_by(sort_options[:attribute], verse: :asc)
          elsif "-#{sort_options[:parameter].to_s}" == request_params['sort']
            expect(response_body).to be_sorted_by(sort_options[:attribute], verse: :desc)
          else
            expect(response_body).to be_sorted_by(nil)
          end
        }
      end

      def should_satisfy_expectations_in(&block)
        it { instance_exec(response_body, @request_params, &block) }
      end

      ## Attributes... might clean them up
      def should_include_attributes(attributes, ancestors = [], can_be_nil=false)
        attributes.each do |name, options = {}|
          should_match_attributes name, options, ancestors, can_be_nil
          should_include_nested_attributes name, options, ancestors
        end
      end

      def should_match_attributes(name, options, ancestors, can_be_nil)
        it {
          parent = ancestors.inject(response_body) do |chain, ancestor|
            Array.wrap(chain).map{|item| item[ancestor.to_s]}.flatten
          end
          expect(parent).to have_attribute(name, options.merge(parent_can_be_nil: can_be_nil, parent_can_be_empty: true))
        }
      end

      def should_include_nested_attributes(name, options, ancestors)
        attributes = options.fetch :attributes, {}
        should_include_attributes attributes, ancestors + [name], options[:can_be_nil]
      end
    end
  end
end