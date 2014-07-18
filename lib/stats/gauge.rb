module Stats
  module Gauge

    def self.places_count
      StatsMix.track 'places.count', Nouns::Place.count
    end

    def self.things_count
      StatsMix.track 'things.count', Nouns::Thing.count
    end

    def self.users_count
      StatsMix.track 'users.count', User.count
    end

    def self.foursquare_rate_limit

    end

  end
end
