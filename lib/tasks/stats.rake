namespace :stats do

  task hourly: :environment do
    Stats::Gauge.places_count
    Stats::Gauge.things_count
    Stats::Gauge.users_count
  end

  task daily: :environment do
    # none :/
  end

  task continuous: :environment do
    # Stats::Gauge.foursquare_rate_limit
  end

end
