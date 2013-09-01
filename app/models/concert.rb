class Concert < ActiveRecord::Base
  validates_presence_of :where
end
