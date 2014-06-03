FactoryGirl.define do

  factory :place, class: Nouns::Place do

    name Faker::Company.name
    latitude Faker::Address.latitude
    longitude Faker::Address.longitude

    foursquare_id { "fake_#{SecureRandom.hex(4)}" }
    # todo: data
    foursquare_data {}

  end

end
