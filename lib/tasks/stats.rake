namespace :stats do

  task hourly: :environment do
    Stats::Gauge.places_count
    Stats::Gauge.things_count
    Stats::Gauge.users_count
  end

  # this resets hourly
  # Stats::Gauge.foursquare_rate_limit

end
