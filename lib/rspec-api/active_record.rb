
module DSL
  module ActiveRecord
    module Route
      extend ActiveSupport::Concern

      module ClassMethods
        def setup_fixtures
          additional = rspec_api[:sort] && rspec_api[:array]
          before_create_fixtures additional
          after_destroy_fixtures
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

      private

        def before_create_fixtures(additional)
          model = rspec_api[:resource_name].singularize.constantize
          before(:all) do
            # TODO: Don't hard-code where, use the type and can_be_nil of attributes
            model.create! where: 'here', year: 2010
            model.create! where: 'here', year: 2000 if additional
          end
        end

        def after_destroy_fixtures
          model = rspec_api[:resource_name].singularize.constantize
          after(:all) { model.destroy_all }
        end
      end
    end
  end
end

RSpec.configuration.include DSL::ActiveRecord::Route, rspec_api_dsl: :route