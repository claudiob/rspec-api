require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Concerts', accepts: :json, returns: :json do
  has_attribute :where, :string
  has_attribute :year, :integer, can_be_nil: true

  accepts filter: :when, on: :year, given: existing(:year) do |concerts|
    concerts.each do |concert|
      expect(concert['year']).to eq request_params[:when]
    end
  end

  accepts sort: :time, on: :year do |concerts|
    expect(concerts).to be_sorted_by :year
  end

  accepts page: :page


  get '/concerts', array: true do
    with no_params do respond_with :ok end
  end

  get '/locations/:location/concerts', array: true do
    with location: apply(:downcase, to: existing(:where)) do
      respond_with :ok do |concerts|
        concerts.each do |concert|
          expect(concert['where'].downcase).to eq request_params[:location]
        end
      end
    end
  end

  get '/concerts/:id' do
    with id: existing(:id) do respond_with :ok end
    with id: unknown(:id) do respond_with :not_found end
  end

  post '/concerts' do
    with valid concert: {where: 'Austin'} do
      respond_with :created do |concert|
        expect(concert['where']).to eq 'Austin'
      end
    end

    with invalid concert: {year: 2013} do
      respond_with :unprocessable_entity do |errors|
        expect(errors["where"]).to eq ["can't be blank"]
      end
    end
  end

  put '/concerts/:id' do
    with id: existing(:id), concert: {year: 2011} do
      respond_with :ok do |concert|
        expect(concert["year"]).to be 2011
      end
    end

    with id: unknown(:id), concert: {year: 2011} do
      respond_with :not_found
    end
  end

  delete '/concerts/:id' do
    with id: existing(:id) do respond_with :no_content end
    with id: unknown(:id) do respond_with :not_found end
  end
end