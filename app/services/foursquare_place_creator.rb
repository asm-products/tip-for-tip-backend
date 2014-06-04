# Retrieves venue data from foursquare and creates a Nouns::Place instance for it.
# The service request returns the created place.
class FoursquarePlaceCreator
  include FoursquareClient

  def call(id)
    data = foursquare_client.venue id
    place = create_place_from data
    Rails.logger.info "Record created for Foursquare place: #{place.foursquare_id} (#{place.name})"
    place
  end

  private

  # Public: Create a new place based on foursquare data. This will
  # populate appropriate fields from their parallels in the foursquare
  # data.
  def create_place_from data
    ::Nouns::Place.create! foursquare_id: data.id,
      name: data.name,
      latitude: data.location.lat,
      longitude: data.location.lng,
      foursquare_data: data.to_hash
  end

end
