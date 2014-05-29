FactoryGirl.define do
  factory :identity do
    trait :expired do
      token_expires_at 1.day.ago
    end

    uid SecureRandom.hex(1)
    provider "facebook"
    token SecureRandom.hex(2)
    token_expires_at 1.week.from_now
  end

  factory :facebook_identity do
    provider "facebook"
  end

  factory :twitter_identity do
    provider "twitter"
  end
end
