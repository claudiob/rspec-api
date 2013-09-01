require 'spec_helper'

describe 'Basic Concerts API', accepts: :json, returns: :json do
  before do
    Concert.create where: 'Coachella', year: 2013
    Concert.create where: 'Woodstock', year: 1969
  end

  it 'lists all concerts' do
    get '/concerts'

    respond_with 200 do |concerts|
      expect(concerts).to eq [{"where"=>"Coachella", "year"=>2013}, {"where"=>"Woodstock", "year"=>1969}]
    end
  end

  it 'shows a concert given an existing ID' do
    get '/concerts/2'

    respond_with 200 do |concert|
      expect(concert).to eq "where"=>"Woodstock", "year"=>1969
    end
  end

  it 'returns an error when showing a concert with an unknown ID' do
    get '/concerts/3'

    respond_with 404
  end

  it 'creates a concert given valid data' do
    post '/concerts', concert: {where: 'Austin'}

    respond_with 201 do |concert|
      expect(concert).to eq "where"=>"Austin", "year"=>nil
    end
  end

  it 'returns an error when creating a concert with invalid data' do
    post '/concerts', concert: {year: 2013}

    respond_with 422 do |errors|
      expect(errors).to eq "where"=>["can't be blank"]
    end
  end

  it 'updates a concert given an existing ID' do
    put '/concerts/1', concert: {year: 2011}

    respond_with 200 do |concert|
      expect(concert).to eq "where"=>"Coachella", "year"=>2011
    end
  end

  it 'returns an error when updating a concert with an unknown ID' do
    put '/concerts/3', concert: {year: 2011}

    respond_with 404
  end

  it 'deletes a concert given an existing ID' do
    delete '/concerts/1'

    respond_with 204
  end

  it 'returns an error when deleting a concert with an unknown ID' do
    delete '/concerts/3'

    respond_with 404
  end
end