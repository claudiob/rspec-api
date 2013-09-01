require 'spec_helper'

describe 'Basic Concerts API' do
  before do
    Concert.create where: 'Coachella', year: 2013
    Concert.create where: 'Woodstock', year: 1969
  end

  it 'lists all concerts' do
    get '/concerts', format: :json

    expect(last_response.status).to be 200
    expect(last_response.headers['Content-Type']).to eq 'application/json; charset=utf-8'
    expect(last_response.body).to eq '[{"where":"Coachella","year":2013},{"where":"Woodstock","year":1969}]'
  end

  it 'shows a concert given an existing ID' do
    get '/concerts/2', format: :json

    expect(last_response.status).to be 200
    expect(last_response.headers['Content-Type']).to eq 'application/json; charset=utf-8'
    expect(last_response.body).to eq '{"where":"Woodstock","year":1969}'
  end

  it 'returns an error when showing a concert with an unknown ID' do
    get '/concerts/3', format: :json

    expect(last_response.status).to be 404
  end

  it 'creates a concert given valid data' do
    post '/concerts', concert: {where: 'Austin'}, format: :json

    expect(last_response.status).to be 201
    expect(last_response.headers['Content-Type']).to eq 'application/json; charset=utf-8'
    expect(last_response.body).to eq '{"where":"Austin","year":null}'
  end

  it 'returns an error when creating a concert with invalid data' do
    post '/concerts', concert: {year: 2013}, format: :json

    expect(last_response.status).to be 422
    expect(last_response.headers['Content-Type']).to eq 'application/json; charset=utf-8'
    expect(last_response.body).to eq '{"where":["can\'t be blank"]}'
  end

  it 'updates a concert given an existing ID' do
    put '/concerts/1', concert: {year: 2011}, format: :json

    expect(last_response.status).to be 200
    expect(last_response.headers['Content-Type']).to eq 'application/json; charset=utf-8'
    expect(last_response.body).to eq '{"where":"Coachella","year":2011}'
  end

  it 'returns an error when updating a concert with an unknown ID' do
    put '/concerts/3', concert: {year: 2011}, format: :json

    expect(last_response.status).to be 404
  end

  it 'deletes a concert given an existing ID' do
    delete '/concerts/1', format: :json

    expect(last_response.status).to be 204
  end

  it 'returns an error when deleting a concert with an unknown ID' do
    delete '/concerts/3', format: :json

    expect(last_response.status).to be 404
  end
end