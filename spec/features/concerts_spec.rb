require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Concerts', accepts: :json, returns: :json do
  before do
    Concert.create where: 'Coachella', year: 2013
    Concert.create where: 'Woodstock', year: 1969
  end

# now the problem with this test and documentation is that we are testing one
# specific case, depending on the exact fixtures above! It would be much better
# if you could tell our users what to expect IN EVERY CASE, not just with these
# given fixtures. So they know for instance how to parse it. What do they get?
# A JSON, sure, but is it an array? Or a hash? Which keys does it include? Which
# types are the values in? All this information is very valuable to API clients,
# and also if you know this, we can have tests that ensure that what we promise
# to our clients is actually what happens. So let's start by the INDEX. We
# don't need to test that the exact parsed JSON is [{"where"=>"Coachella", "year"=>2013}, {"where"=>"Woodstock", "year"=>1969}]
# This is not very valuable or intuitive as a description, and the test is
# dependent on the fixture. But what we can test (and describe) generically is:
# 1) we will return (in JSON) an ARRAY
# 2) each array item will be (in JSON) a HASH
# 3) each item will have the key "where" and a String
# 4) each item will have the key "year" and an Integer or nil.
#
# Then, just specific to the fixtures above, we can check the size
  get '/concerts', array: true do
    example_request 'Get the list of concerts' do
      respond_with 200 do |concerts|
        expect(concerts.map{|c| c['where']}.all? {|value| value.is_a? String}).to be_true
        expect(concerts.map{|c| c['year']}.compact.all? {|value| value.is_a? Integer}).to be_true

        expect(concerts).not_to be_empty
        expect(concerts.size).to be 2
      end
    end
  end

  get '/concerts/:id' do
    example_request 'Get an existing concert', id: 2 do
      respond_with 200 do |concert|
        expect(concert['where']).to be_a String
        expect(concert['year']).to be_an Integer if concert['year']
      end
    end

    example_request 'Get an unknown concert', id: 3 do
      respond_with 404
    end
  end

  post '/concerts' do
    example_request 'Create a valid concert', concert: {where: 'Austin'} do
      respond_with 201 do |concert|
        expect(concert['where']).to be_a String
        expect(concert['year']).to be_an Integer if concert['year']

        expect(concert['where']).to eq 'Austin'
      end
    end

    example_request 'Create an invalid concert', concert: {year: 2013} do
      respond_with 422 do |errors|
        expect(errors["where"]).to eq ["can't be blank"]
      end
    end
  end

  put '/concerts/:id' do
    example_request 'Update an existing concert', id: 1, concert: {year: 2011} do
      respond_with 200 do |concert|
        expect(concert['where']).to be_a String
        expect(concert['year']).to be_an Integer if concert['year']

        expect(concert["year"]).to be 2011
      end
    end

    example_request 'Update an unknown concert', id: 3, concert: {year: 2011} do
      respond_with 404
    end
  end

  delete '/concerts/:id' do
    example_request 'Delete an existing concert', id: 1 do
      respond_with 204
    end

    example_request 'Delete an unknown concert', id: 3 do
      respond_with 404
    end
  end
end