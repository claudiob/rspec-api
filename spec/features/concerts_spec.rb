require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource 'Concerts', accepts: :json, returns: :json do
  has_attribute :where, String
  has_attribute :year, Integer, can_be_nil: true

  # How to make this spec even more generic and good for documentation?

  # Let's talk about that not_to be_empty check. What exactly do we mean?
  # We mean that if we have some concerts in the DB then /concerts should
  # not be empty. Does not matter their content. Now, if we didn't have
  # them, the rest of the test would still pass, because it would check the
  # attributes of NOTHING. But then it wouldn't be a meaningful test. If
  # suddenly we changed the attributes, the test would not fail! In other
  # words, it is really IMPORTANT that whenever we run the test for INDEX
  # we do have SOME instances in the DB, otherwise we are not fully testing.
  # And even in the documentation, we would not have any example output.
  # In general, testing with NO items in a DB is just a subcase, we do want
  # elements so we can fully test. So we can write this:
  before do
    setup_instances
  end

  get '/concerts', array: true do
    example_request 'Get the list of concerts' do
      respond_with :ok do |concerts|
        expect(concerts.size).to be 2
      end
    end
  end

  get '/concerts/:id' do
    example_request 'Get an existing concert', id: 2 do
      respond_with :ok
    end

    example_request 'Get an unknown concert', id: 3 do
      respond_with :not_found
    end
  end

  # Let's talk about those :id.. looks like only /concerts/2 is OK and
  # concerts/3 is not, but what we want to express is something different
  # what we mean is: if you pass the id of an existing instance then OK
  # otherwise KO. How can we do this WITHOUT depending on the instances
  # above?



  post '/concerts' do
    example_request 'Create a valid concert', concert: {where: 'Austin'} do
      respond_with :created do |concert|
        expect(concert['where']).to eq 'Austin'
      end
    end

    example_request 'Create an invalid concert', concert: {year: 2013} do
      respond_with :unprocessable_entity do |errors|
        expect(errors["where"]).to eq ["can't be blank"]
      end
    end
  end

  put '/concerts/:id' do
    example_request 'Update an existing concert', id: 1, concert: {year: 2011} do
      respond_with :ok do |concert|
        expect(concert["year"]).to be 2011
      end
    end

    example_request 'Update an unknown concert', id: 3, concert: {year: 2011} do
      respond_with :not_found
    end
  end

  delete '/concerts/:id' do
    example_request 'Delete an existing concert', id: 1 do
      respond_with :no_content
    end

    example_request 'Delete an unknown concert', id: 3 do
      respond_with :not_found
    end
  end
end