class Concert < ActiveRecord::Base
  validates_presence_of :where

  def self.filter(filters = {})
    location = filters[:location]
    location ? where('lower(`where`) = ?', location.downcase) : all
  end
end
