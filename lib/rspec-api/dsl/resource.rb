module DSL
  module Resource
    extend ActiveSupport::Concern

    module ClassMethods
      def self.define_action(verb)
        define_method verb do |route, args = {}, &block|
          rspec_api.merge! array: args.delete(:array), verb: verb, route: route
          args.merge! rspec_api_dsl: :route
          describe("#{verb.upcase} #{route}", args, &block)
        end
      end

      define_action :get
      define_action :put
      define_action :post
      define_action :delete

      def has_attribute(name, type, options = {})
        parent = (@attribute_ancestors || []).inject(rspec_api) {|chain, step| chain[:attributes][step]}
        (parent[:attributes] ||= {})[name] = options.merge(type: type)
        nested_attribute(name, &Proc.new) if block_given?
      end

      def accepts_page(page_parameter)
        rspec_api[:page] = page_parameter
      end

    private

      def nested_attribute(name)
        (@attribute_ancestors ||= []).push name
        yield
        @attribute_ancestors.pop
      end
    end
  end
end
