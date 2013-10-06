RSpec::Matchers.define :have_json_content_type do
  match do |response|
    response_headers['Content-Type'] == 'application/json; charset=utf-8'
  end

  description do
    "include 'Content-Type': 'application/json; charset=utf-8'"
  end

  failure_message_for_should do |item|
    %Q(should include 'Content-Type': 'application/json; charset=utf-8', but are #{response_headers})
  end
end