FactoryGirl.define do

  factory :user do
    first_name "Bruce"
    last_name "Chelmsford"
    email { "test_#{SecureRandom.hex(4)}@example.com" }
    username { "#{first_name}#{last_name}#{SecureRandom.hex(4)}" }
    locale 'en_US'
    timezone "-7"
  end

  factory :primary_user, parent: :user do

  end

end
