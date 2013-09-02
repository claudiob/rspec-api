require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Concerts', accepts: :json, returns: :json do
  has_attribute :where, :string
  has_attribute :year, :integer, can_be_nil: true

  get '/concerts', array: true do
    request 'Get the list of concerts' do
      respond_with :ok do |concerts|
        expect(concerts.size).to be instances.count
      end
    end
  end

  get '/concerts/:id' do
    request 'Get an existing concert', id: existing(:id) do
      respond_with :ok
    end

    request 'Get an unknown concert', id: unknown(:id) do
      respond_with :not_found
    end
  end

  post '/concerts' do
    request 'Create a valid concert', concert: {where: 'Austin'} do
      respond_with :created do |concert|
        expect(concert['where']).to eq 'Austin'
      end
    end

    request 'Create an invalid concert', concert: {year: 2013} do
      respond_with :unprocessable_entity do |errors|
        expect(errors["where"]).to eq ["can't be blank"]
      end
    end
  end

  put '/concerts/:id' do
    request 'Update an existing concert', id: existing(:id), concert: {year: 2011} do
      respond_with :ok do |concert|
        expect(concert["year"]).to be 2011
      end
    end

    request 'Update an unknown concert', id: unknown(:id), concert: {year: 2011} do
      respond_with :not_found
    end
  end

  delete '/concerts/:id' do
    request 'Delete an existing concert', id: existing(:id) do
      respond_with :no_content
    end

    request 'Delete an unknown concert', id: unknown(:id) do
      respond_with :not_found
    end
  end
end