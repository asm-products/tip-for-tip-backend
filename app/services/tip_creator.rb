# Handles the complexities of creating a tip.
class TipCreator

  # Expects the user and noun to be included in the params.
  def call(params)
    params.symbolize_keys!

    tip = Tip.new params
    tip.user = params[:user]
    tip.noun = params[:noun]
    tip.save!

    tip
  end

end
