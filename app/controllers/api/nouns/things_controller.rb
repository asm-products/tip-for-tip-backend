class Api::Nouns::ThingsController < ApiController

  before_filter :authenticate_user_from_token!

  def show
    id = show_params[:thing_id]
    @thing = ::Nouns::Thing.where('id = ? OR uuid = ?', id, id).first!
  end

  private

  def show_params
    params.require(:thing_id)
    params.permit(:thing_id)
  end

end
