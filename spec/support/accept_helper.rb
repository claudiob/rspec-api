require 'spec_helper'

def accepts(options = {}, &block)
  parameters = block_given? ? options.merge(block: block) : options
  (metadata[:query_parameters] ||= []).push parameters
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

def query_parameters_requests
  metadata.fetch(:query_parameters, []).map do |params|
    if params.has_key? :filter
      filter_parameters_requests params
    elsif params.has_key? :sort
      sort_parameters_requests params
    elsif params.has_key? :page
      page_parameters_requests params
    end
  end.flatten
end

def filter_parameters_requests(params)
  params.except(:given, :block).tap do |req|
    value = params.fetch :given, apply(:as_json, to: existing(params[:on]))
    req[:description] = " filtered by #{params[:filter]}"
    req[:request_params] = {params[:filter] => value}
    req[:block] = params[:block]
  end
end

def sort_parameters_requests(params)
  [true, false].map do |ascending|
    params.except(:block).tap do |req|
      req[:description] = " sorted by #{params[:sort]} #{ascending ? '↑' : '↓'}"
      req[:request_params] = {sort: "#{ascending ? '' : '-'}#{params[:sort]}"}
      req[:block] = params[:block]
    end
  end
end

def page_parameters_requests(params)
  {}.tap do |req|
    req[:description] = " paginated by #{params[:page]}"
    (req[:request_params] = {})[params[:page]] = 1
    req[:min_pages] = 2
    req[:block] = -> _ { assert_pagination_links }
  end
end