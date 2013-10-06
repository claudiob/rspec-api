
module DSL
  module ActiveRecord
    module Route
      extend ActiveSupport::Concern

      module ClassMethods
        def setup_fixtures
          setup_one_fixture
        end

        def setup_one_fixture
          model = rspec_api[:resource_name].singularize.constantize
          # TODO: Don't hard-code where, use the type and can_be_nil of attributes
          before(:all) { @fixture = model.first_or_create! where: 'here' }
          after(:all) { @fixture.destroy }
        end

        def existing(field)
          model = rspec_api[:resource_name].singularize.constantize
          -> { model.pluck(field).first }
        end

        def unknown(field)
          model = rspec_api[:resource_name].singularize.constantize
          keys = 0.downto(-Float::INFINITY).lazy
          -> { keys.reject {|value| model.exists? field => value}.first }
        end

        def apply(method_name, options = {})
          -> { options[:to].call.send method_name }
        end
      end
    end
  end
end

RSpec.configuration.include DSL::ActiveRecord::Route, rspec_api_dsl: :route