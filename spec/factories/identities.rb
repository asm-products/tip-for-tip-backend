FactoryGirl.define do
  factory :identity do
    trait :expired do
      token_expires_at 1.day.ago
    end

    trait :facebook do
      provider "facebook"
    end

    trait :twitter do
      provider "twitter"
    end

    facebook
    uid { SecureRandom.hex(4) }
    token { SecureRandom.hex(4) }
    token_expires_at 1.week.from_now
  end

  factory :facebook_identity do
    facebook
  end

  factory :twitter_identity do
    twitter
  end
end
