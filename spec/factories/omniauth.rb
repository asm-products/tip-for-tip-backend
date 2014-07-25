
# Builds auth objects for the various omniauth providers.
FactoryGirl.define do

  factory :omniauth, class: OmniAuth::AuthHash do

    sequence :uid
    provider "Foo Provider"

    credentials do
      {
        expires: true,
        expires_at: 1.week.from_now.to_i,
        token: "fake_token"
      }
    end

  end

  factory :facebook_omniauth, parent: :omniauth do
    provider :facebook

    info do
      {
        email: 'bruce.chelmsford@example.com',
        first_name: 'Bruce',
        last_name: 'Chelmsford',
        image: 'http://placehold.it/150x150',
        location: 'Portland, Oregon',
        name: 'Bruce Chelmsford',
        nickname: "brucey",
        urls: {
          Facebook: 'https://www.example.com/brucey'
        },
        verified: true,
        provider: 'facebook',
        uid: '12345',

      }
    end

    extra do
      {
        raw_info: {
          about: Faker::Lorem.sentence,
          email: 'bruce.chelmsford@example.com',
          first_name: 'Bruce',
          gender: 'male',
          hometown: {
            id: '10987654',
            name: 'Portland, Oregon'
          },
          id: '12345',
          last_name: 'Chelmsford',
          link: 'https://www.example.com/brucey',
          locale: 'en_US',
          location: {
            id: '10987654',
            name: 'Portland, Oregon'
          },
          name: 'Bruce Chelmsford',
          political: Faker::Lorem.words(2),
          quotes: Faker::Lorem.sentence,
          religion: Faker::Lorem.sentence,
          timezone: -7,
          updated_time: 1.week.ago.iso8601,
          username: 'brucey',
          verified: true,

          work: [
            employer: {
              id: '5555',
              name: 'Fake Company'
            },
            start_data: "2014-03-11"
          ]
        }
      }
    end

  end

end
