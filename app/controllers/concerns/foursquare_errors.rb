module FoursquareErrors
  extend ActiveSupport::Concern

  included do
    rescue_from Foursquare2::APIError, with: :handle_foursquare_api_error
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
