module FoursquareClient
  extend ActiveSupport::Concern

  private

  def foursquare_client
    options = foursquare_credentials.merge api_version: '20140520'

    unless @foursquare_client
      @foursquare_client = Foursquare2::Client.new options# do |client|
        # client.builder.use :instrumentation
        # client.builder.use StatsMiddleware
      # end
      # @foursquare_client.builder.use StatsMiddleware
    end
    @foursquare_client
  end

  def foursquare_credentials
    @foursquare_creds ||= {
      client_id: Rails.application.secrets.foursquare['client_id'],
      client_secret: Rails.application.secrets.foursquare['client_secret']
    }
  end

  # Adds stat tracking middleware to the foursquare request/responses.
  # class StatsMiddleware
  #   def initialize(app, options = {})
  #     super(app)
  #   end

  #   def call(env)
  #     # do something with the request
  #     # TODO: track number of foursquare requests?
  #     @app.call(env).on_complete do
  #       # do something with the response
  #       # Stats::Gauge.foursquare_rate_limit
  #       puts "STats middleware!!"
  #       p env[:response_headers]
  #     end
  #   end
  # end

  # Foursquare2.connection_middleware = [StatsMiddleware]

end
