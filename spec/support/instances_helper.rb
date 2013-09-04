require 'spec_helper'
require 'rspec_api_documentation/dsl'

def setup_instances
  instances.create random_values_for_attributes
  instances.create random_values_for_attributes
  stub_instances_total_pages example.metadata[:min_pages]
end

def instances
  example.metadata[:resource_name].singularize.constantize
end

def assert_instances(json)
  expect(json).not_to be_empty
end

def existing(key)
  -> { instances.pluck(key).first }
end

def unknown(key)
  keys = 0.downto(-Float::INFINITY).lazy
  -> { keys.reject {|value| instances.exists? key => value}.first }
end

def apply(method_name, options = {})
  proc = options[:to]
  -> { proc.call.send method_name }
end

def stub_instances_total_pages(total_pages)
  page_method = instances.method :page
  instances.stub(:page) do |page|
    page_method.call(page).tap do |proxy|
      proxy.stub(:total_pages).and_return total_pages
    end
  end if total_pages
end