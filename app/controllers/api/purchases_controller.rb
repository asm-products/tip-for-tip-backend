class Api::PurchasesController < ApiController
  before_filter :authenticate_user_from_token!

  def create

    request_metadata = {
      user_agent: request.user_agent,
      request_id: request.uuid,
      ip: request.ip,
      remote_ip: request.remote_ip,
      jailbroken: request.headers['X-Jailbroken']
    }

    @tip = find_tip
    @purchase = case params[:service].to_sym

    when :itunes
      ItunesPurchaseCreator.new.(current_user, @tip, params[:transaction_id], params[:receipt_data], request_metadata: request_metadata)
    when :google
      raise NotYetImplementedError
    end

    if @purchase
      render status: :created
    else
      # TODO: find a way to get the verification directly from the service
      verification = current_user.iap_receipt_verifications.last

      render status: :bad_request, json: { message: verification.result_message }
    end
  end

  private

  def find_tip
    id = purchase_params[:tip_id]
    ::Tip.where('id = ? OR uuid = ?', id, id).first!
  end

  def purchase_params
    keys = %w{ tip_id service receipt_data transaction_id }
    keys.each{ |key| params.require key }
    params.permit *keys
  end
  memoize :purchase_params

end
