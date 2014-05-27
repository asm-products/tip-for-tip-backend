FactoryGirl.define do

  factory :user do |user|
    first_name "Bruce"
    last_name "Chelmsford"
    email { "test_#{SecureRandom.hex(4)}@example.com" }
    username { "#{first_name}#{last_name}#{SecureRandom.hex(4)}" }
    locale 'en_US'
    timezone "-7"

    trait :with_identity do
      # user.after_create { |l| FactoryGirl.create(:identity, user_id: user.id)  }
      # identities { build_list :identity, 1, user_id: user.id }
      after(:create) do |user|
        FactoryGirl.create_list(:identity, 1, user_id: user.id)
      end
    end
  end

  factory :primary_user, parent: :user do

  end

end
