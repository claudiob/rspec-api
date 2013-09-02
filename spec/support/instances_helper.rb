require 'spec_helper'
require 'rspec_api_documentation/dsl'

def setup_instances
  instances.create random_values_for_attributes
  instances.create random_values_for_attributes
end
  # Now the only thing left hard-coded are these instances. What is bad about
  # this? Two things: we are writing tests for VERY SPECIFIC cases in the
  # database, and also our documentation will ALWAYS show these examples, as
  # though these were the only things ever returned by our API. But actually
  # we can express this in a more meaningful way. All we need is to create
  # some instances where the attributes have any random value for their type.
  # And we already know the types, they are in our attributes list! And not
  # only that, but we also know which attributes can be nil, so for those
  # we don't even have to always set a value (year). So we can write the
  # following (note that for now, one instance is enough for all tests)

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