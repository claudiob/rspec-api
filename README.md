# RSpec API

## Todo

* Don't have the second `accept_***` override the first one
* Warn if the app declares matchers with the same name, like `be_filtered_by`
* Have something for ActiveRecord, otherwise accounts_spec.rb won't run
* Add `accepts_limit` and `accepts_offset`
* Add block to `accepts_filter` for a way to compare
* Cache results from Github or any other remote resource
* use ActiveSupport::Autoload
* nest "should include the field" if the attribute is nested
* should `success?` be (200..299).include?(status) ?
* Instead of

        get '/concerts', array: true do
          request do
            respond_with :ok
          end
        end

I could have the syntax

        get '/concerts' do
          request do
            respond_with :ok, array: true
          end
        end

except that it wouldn't know to make multiple requests for all the `accepts_`.
So I might need to change the key name `array` to `accepts` or similar.

* I might drop the need for `request do`, and have `respond_with` accepted one
level higher, implicitly inserting a `request do` for a short syntax, e.g.:

        get '/apples' do
          respond_with :ok
        end
