require 'spec_helper'

def accepts_sort(name, options = {}, &block)
  metadata[:sort_parameters] = options.merge name: name, block: block
end

RSpec::Matchers.define :be_sorted_by do |attribute|
  match do |items|
    values = items.map{|item| item[attribute.to_s]}
    values == values.sort
  end
end