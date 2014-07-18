class Api::Nouns::PlacesController < ApiController
  include FoursquareClient
  include FoursquareErrors

  before_filter :authenticate_user_from_token!

  def show
    id = show_params[:place_id]
    @place = ::Nouns::Place.where('id = ? OR uuid = ?', id, id).first!
  end

  def foursquare_show
    @place = ::Nouns::Place.find_by foursquare_id: foursquare_show_params[:foursquare_id]

    unless @place
      response.status = :created
      @place = FoursquarePlaceCreator.new.(foursquare_show_params[:foursquare_id])
      Stats.foursquare_place_created
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

end
