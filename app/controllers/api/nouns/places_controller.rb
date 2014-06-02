class Api::Nouns::PlacesController < ApplicationController
  include TokenAuthentication
  include FoursquareClient

  before_filter :authenticate_user_from_token
  before_filter :authenticate_user!

  rescue_from Foursquare2::APIError, with: :handle_foursquare_api_error

  def show
    id = show_params[:place_id]
    @place = ::Nouns::Place.where('id = ? OR uuid = ?', id, id).first
    raise ActiveRecord::RecordNotFound.new(show_params[:place_id]) unless @place
  end

  def foursquare_show
    @place = ::Nouns::Place.find_by foursquare_id: foursquare_show_params[:foursquare_id]

    unless @place
      response.status = :created
      @place = fetch_and_create_from_foursquare(foursquare_show_params[:foursquare_id])
    end

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

  def fetch_and_create_from_foursquare id
    data = foursquare_client.venue id
    place = ::Nouns::Place.create_from_foursquare! data
    logger.info "Record created for Foursquare place: #{place.foursquare_id} (#{place.name})"
    place
  end

  def handle_foursquare_api_error e
    code = e.code.to_i
    # We treat url param and body param errors differently.
    if code == 400 && e.message =~ /is invalid for venue id/
      render status: :not_found, json: { error: :not_found }
    else
      logger.warn "TODO: handle error responses better."
      render status: code, json: { error: e.message }
    end
  end

end
