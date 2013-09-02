require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Concerts', accepts: :json, returns: :json do
  before do
    Concert.create where: 'Coachella', year: 2013
    Concert.create where: 'Woodstock', year: 1969
  end

  get '/concerts' do
    example_request 'lists all concerts' do
      respond_with 200 do |concerts|
        expect(concerts).to eq [{"where"=>"Coachella", "year"=>2013}, {"where"=>"Woodstock", "year"=>1969}]
      end
    end
  end

  get '/concerts/2' do
    example_request 'shows a concert given an existing ID' do
      respond_with 200 do |concert|
        expect(concert).to eq "where"=>"Woodstock", "year"=>1969
      end
    end
  end

  get '/concerts/3' do
    example_request 'returns an error when showing a concert with an unknown ID' do
      respond_with 404
    end
  end

  post '/concerts' do
    example_request 'creates a concert given valid data', concert: {where: 'Austin'} do
      respond_with 201 do |concert|
        expect(concert).to eq "where"=>"Austin", "year"=>nil
      end
    end
  end

  post '/concerts' do
    example_request 'returns an error when creating a concert with invalid data', concert: {year: 2013} do
      respond_with 422 do |errors|
        expect(errors).to eq "where"=>["can't be blank"]
      end
    end
  end

  put '/concerts/1' do
    example_request 'updates a concert given an existing ID', concert: {year: 2011} do
      respond_with 200 do |concert|
        expect(concert).to eq "where"=>"Coachella", "year"=>2011
      end
    end
  end

  put '/concerts/3' do
    example_request 'returns an error when updating a concert with an unknown ID', concert: {year: 2011} do
      respond_with 404
    end
  end

  delete '/concerts/1' do
    example_request 'deletes a concert given an existing ID' do
      respond_with 204
    end
  end

  delete '/concerts/3' do
    example_request 'returns an error when deleting a concert with an unknown ID' do
      respond_with 404
    end
  end
end