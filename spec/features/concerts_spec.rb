require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Concerts', accepts: :json, returns: :json do
  has_attribute :where, String
  has_attribute :year, Integer, can_be_nil: true

  before do
    Concert.create where: 'Coachella', year: 2013
    Concert.create where: 'Woodstock', year: 1969
  end

  get '/concerts', array: true do
    example_request 'Get the list of concerts' do
      respond_with 200 do |concerts|
        expect(concerts).not_to be_empty
        expect(concerts.size).to be 2
      end
    end
  end

  get '/concerts/:id' do
    example_request 'Get an existing concert', id: 2 do
      respond_with 200 do |concert|
      end
    end

    example_request 'Get an unknown concert', id: 3 do
      respond_with 404
    end
  end

  post '/concerts' do
    example_request 'Create a valid concert', concert: {where: 'Austin'} do
      respond_with 201 do |concert|
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