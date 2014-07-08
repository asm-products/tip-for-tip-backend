class Api::Nouns::ThingsController < ApiController

  before_filter :authenticate_user_from_token!

  def show
    id = show_params[:thing_id]
    @thing = ::Nouns::Thing.where('id = ? OR uuid = ?', id, id).first!
  end

  def create
    ::Nouns::Thing.transaction do
      @thing = ::Nouns::Thing.create! create_params
      NounCreator.create! noun: @thing, user: current_user
    end
    render :show, status: :created
  end

  def search
    @things = ::Nouns::Thing.where(["name LIKE :q", { q: "%#{search_params[:q]}%" }]).limit(20)
    render status: :no_content if @things.empty?
    # TODO: improve searching.
  end

  private

  def show_params
    params.require(:thing_id)
    params.permit(:thing_id)
  end

  def create_params
    params.permit(:name)
  end

  def search_params
    params.permit(:q)
  end

end
