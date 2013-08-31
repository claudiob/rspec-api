require 'spec_helper'

describe 'Basic Concerts API' do
  before do
    Concert.create([{where: 'Coachella', year: 2013}, {where: 'Woodstock', year: 1969}])
    set_headers 'Accept: application/json Content-Type: application/json'
  end

  after do
    it { expect(page.response_headers['Content-Type']).to eq 'application/json; charset=utf-8' }
  end

  describe 'getting the list of concerts' do
    get '/concerts'

    it { expect(page.status_code).to be 200 }
    it { expect(page.body).to be "[{'where': 'Coachella', 'year': 2013}, {'where': 'Woodstock', 'year': 1969}]" }
  end

  describe 'getting an existing concert' do
    get '/concerts/1'

    it { expect(page.status_code).to be 200 }
    it { expect(page.body).to be "{'where': 'Woodstock', 'year': 1969}" }
  end

  describe 'getting an unknown concert' do
    get '/concerts/3'

    it { expect(page.status_code).to be 404 }
  end

  describe 'creating a valid concert' do
    post '/concerts', data: "{concert: {'where': 'Austin'}}"

    it { expect(page.status_code).to be 201 }
    it { expect(page.body).to be "{'where': 'Austin', 'year': null}" }
  end

  describe 'creating a invalid concert' do
    post '/concerts', data: "{concert: {'year': 2013}}"

    it { expect(page.status_code).to be 422 }
    it { expect(page.body).to be %q({"where":["can't be blank"]}) }
  end

  describe 'updating an existing concert' do
    put '/concerts/1', data: "{concert: {'year': 2011}}"

    it { expect(page.status_code).to be 200 }
    it { expect(page.body).to be "{'where': 'Coachella', 'year': 2011}" }
  end

  describe 'updating an unknown concert' do
    put '/concerts/3', data: "{concert: {'year': 2011}}"

    it { expect(page.status_code).to be 404 }
  end

  describe 'deleting an existing concert' do
    delete '/concerts/1'

    it { expect(page.status_code).to be 204 }
  end

  describe 'deleting an unknown concert' do
    delete '/concerts/3'

    it { expect(page.status_code).to be 404 }
  end
end
