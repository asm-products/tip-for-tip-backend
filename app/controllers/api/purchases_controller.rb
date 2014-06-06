class Api::PurchasesController < ApiController
  before_filter :authenticate_user_from_token!

  def create
    @tip = find_tip
    @purchase = case params[:service].to_sym
    when :itunes
      ItunesPurchaseCreator.new.(current_user, @tip, params[:transaction_id], params[:receipt_data])
    when :google
      raise NotYetImplementedError
    end


    render status: 201
  end

  private

  def find_tip
    id = purchase_params[:tip_id]
    tip = ::Tip.where('id = ? OR uuid = ?', id, id).first
    raise ActiveRecord::RecordNotFound.new(purchase_params[:tip_id]) unless tip
    tip
  end

  def purchase_params
    keys = %w{ tip_id service receipt_data transaction_id }
    keys.each{ |key| params.require key }
    params.permit *keys
  end
  memoize :purchase_params


end
