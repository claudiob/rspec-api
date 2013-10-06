RSpec::Matchers.define :have_pagination_links do |page|
  match do |response_headers|
    if page.nil?
      true
    else
      links = response_headers['Link'] || '' # https://github.com/lostisland/faraday/pull/306
      rels = links.split(',').map{|link| link[/<.+?>; rel="(.*)"$/, 1]}
      rels.sort == ['first', 'prev']
    end
  end

  description do
    %Q(include 'Link' (for pagination))
  end

  failure_message_for_should do |response_headers|
    %Q(should #{description}, but are #{response_headers})
  end
end

