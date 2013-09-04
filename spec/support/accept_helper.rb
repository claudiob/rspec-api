require 'spec_helper'

def accepts(options = {}, &block)
  if name = options.delete(:filter)
    metadata[:filter_parameters] = options.merge name: name, block: block
  elsif name = options.delete(:sort)
    metadata[:sort_parameters] = options.merge name: name, block: block
  elsif name = options.delete(:page)
    metadata[:page_parameters] = {name: name}
  end
end

RSpec::Matchers.define :be_sorted_by do |attribute|
  match do |items|
    values = items.map{|item| item[attribute.to_s]}
    values.reverse! if example.metadata[:request_params][:sort][0] == '-'
    values == values.sort
  end
end

def assert_pagination_links
  expect(response_headers).to have_key 'Link'
  links = response_headers['Link'].split(',')
  rels = links.map{|link| link[/<.+?>; rel="(.*)"$/, 1]}
  expect(rels).to match_array ['last', 'next']
end