FactoryGirl.define do

  factory :place, class: Nouns::Place do

    name Faker::Company.name
    latitude Faker::Address.latitude
    longitude Faker::Address.longitude

    foursquare_id '4beb2649b3352d7f2f1b56d2'
    # todo: data
    foursquare_data {}

  end

end
