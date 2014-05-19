FactoryGirl.define do

  factory :place, class: Nouns::Place do

    name Faker::Company.name
    latitude Faker::Address.latitude
    longitude Faker::Address.longitude

    # todo: data
    foursquare_data {}

  end

end
