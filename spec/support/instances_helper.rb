require 'spec_helper'
require 'rspec_api_documentation/dsl'

def setup_instances
  instances.create where: 'Coachella', year: 2013
  instances.create where: 'Woodstock', year: 1969
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