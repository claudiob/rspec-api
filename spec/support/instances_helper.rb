require 'spec_helper'
require 'rspec_api_documentation/dsl'

def setup_instances
  Concert.create where: 'Coachella', year: 2013
  Concert.create where: 'Woodstock', year: 1969
end

def assert_instances(json)
  expect(json).not_to be_empty
end