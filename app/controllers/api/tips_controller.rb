class Api::TipsController < ApiController
  before_filter :authenticate_user_from_token!

  # rescue_from NameError, with: :not_found, only: :create

  def show
    id = show_params[:tip_id]
    @tip = ::Tip.where('id = ? OR uuid = ?', id, id).first!
  end

  def create
    @noun = find_noun
    @tip = TipCreator.new.(create_tip_params.to_hash.merge user: current_user, noun: @noun)
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
    optional_params = %w{ is_compliment is_free display_as send_at }
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
    begin
      clazz = "nouns/#{find_noun_params[:noun_type].underscore}".classify.constantize
      id = find_noun_params[:noun_id]
      clazz.where('id = ? OR uuid = ?', id, id).first!
    rescue NameError => e
      raise ActiveRecord::RecordNotFound, find_noun_params[:noun_type]
    end
  end

end
