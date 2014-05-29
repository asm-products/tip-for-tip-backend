class Api::PartnersController < ApplicationController
  include TokenAuthentication
  before_filter :authenticate_user_from_token!

  def show
    @partner = Partner.find show_params[:partner_id]

    unless @partner.users.pluck(:id).push(@partner.primary_user_id).include? current_user.id
      raise Errors::Unauthorized
    end
  end

  private

  def show_params
    params.require :partner_id
    params.permit :partner_id
  end

end
