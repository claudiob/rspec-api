require 'spec_helper'

def accepts_page(name)
  metadata[:page_parameters] = {name: name}
end

def assert_pagination_links
  expect(response_headers).to have_key 'Link'
  links = response_headers['Link'].split(',')
  rels = links.map{|link| link[/<.+?>; rel="(.*)"$/, 1]}
  expect(rels).to match_array ['last', 'next']
end
