class Nouns::Place < ActiveRecord::Base
  include Noun

  validates_presence_of :name
  validates_presence_of :latitude
  validates_presence_of :longitude
  validates_uniqueness_of :foursquare_id

end
