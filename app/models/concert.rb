class Concert < ActiveRecord::Base
  validates_presence_of :where

  def self.filter(filters = {})
    valid_filters.inject(all) do |where_chain, filter|
      key, scope = filter
      filters[key] ? scope.call(filters[key]) : where_chain
    end
  end

private

  def self.valid_filters
    {
      location: -> location { where('lower(`where`) = ?', location.downcase) },
      when: -> year { where(year: year) }
    }
  end
end