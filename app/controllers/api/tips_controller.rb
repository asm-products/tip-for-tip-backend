class Api::TipsController < ApiController
  before_filter :authenticate_user_from_token!

  rescue_from NameError, with: :not_found, only: :create

  def show
    id = show_params[:tip_id]
    @tip = ::Tip.where('id = ? OR uuid = ?', id, id).first!
  end

  def create
    @noun = find_noun

    # (TODO)
    unless @noun
      render status: 404, json: { message: "Automatic creation of nouns is not yet implemented." }
    end

    @tip = Tip.new create_tip_params
    @tip.user = current_user
    @tip.noun = @noun
    @tip.save!

    render :show, status: :created
  end

  private

  def show_params
    params.require :tip_id
    params.permit :tip_id
  end
  memoize :show_params

  def create_tip_params
    required_params = %w{ subject body }
    optional_params = %w{ is_annonymous can_purchase_with_reputation send_at }
    required_params.each{ |p| params.require p }
    params.permit required_params + optional_params
  end
  memoize :create_tip_params

  def find_noun_params
    params.require :noun_type
    params.require :noun_id
    params.permit :noun_type, :noun_id
  end
  memoize :find_noun_params

  def find_noun
    clazz = "nouns/#{find_noun_params[:noun_type].underscore}".classify.constantize
    id = find_noun_params[:noun_id]
    clazz.where('id = ? OR uuid = ?', id, id).first!
  end

end