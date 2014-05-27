class Nouns::Place < ActiveRecord::Base
  include Noun

  validates_presence_of :name
  validates_presence_of :latitude
  validates_presence_of :longitude
  validates_uniqueness_of :foursquare_id

  # Public: Create a new place based on foursquare data. This will
  # populate appropriate fields from their parallels in the foursquare
  # data.
  def self.create_from_foursquare! data
    create! foursquare_id: data.id,
      name: data.name,
      latitude: data.location.lat,
      longitude: data.location.lng,
      foursquare_data: data.to_hash
  end
end
