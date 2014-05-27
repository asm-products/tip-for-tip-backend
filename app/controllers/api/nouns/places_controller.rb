class Api::Nouns::PlacesController < ApplicationController
  include TokenAuthentication
  include FoursquareClient

  before_filter :authenticate_user_from_token
  before_filter :authenticate_user!

  def show
    @place = ::Nouns::Place.find show_params[:place_id]
  end

  def foursquare_show
    @place = ::Nouns::Place.find_by foursquare_id: foursquare_show_params[:foursquare_id]
    @place ||= fetch_and_create_from_foursquare(foursquare_show_params[:foursquare_id])

    render :show
  end

  private

  def show_params
    params.require(:place_id)
    params.permit(:place_id)
  end

  def foursquare_show_params
    params.require(:foursquare_id)
    params.permit(:foursquare_id)
  end

  def fetch_and_create_from_foursquare(id)
    data = foursquare_client.venue id
    place = ::Nouns::Place.create_from_foursquare! data
    logger.info "Record created for Foursquare place: #{place.foursquare_id} (#{place.name})"
    place
  end

end
