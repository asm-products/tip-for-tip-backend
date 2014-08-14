source 'https://rubygems.org'

ruby '2.1.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.1'
# Use mysql as the database for Active Record
gem 'mysql2'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'memoist' # One line memoization of instance methods.

gem 'venice', github: 'amoslanka/venice' # iTunes IAP receipt validation
gem 'plutus' # Double Entry Accounting framework

gem 'foursquare2'

# Notifications and Email
gem 'mandrill-api'
gem 'mandrill_mailer'

gem 'devise'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'

gem 'paypal-sdk-adaptivepayments'

# Cross Origin Resource Sharing
gem 'rack-cors'
gem 'redcarpet'

# NewRelic monitoring and reporting
gem 'newrelic_rpm'

gem 'rollbar'
gem 'statsmix'

# Use unicorn as the app server
gem 'unicorn'


# TODO Later
# gem 'paper_trail'
# gem 'pubnub'



group :development do
  gem 'spring'
  gem 'pry'
  gem 'pry-doc'
  gem 'pry-rails'
  gem 'pry-remote'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'foreman'
  # problem with apiary gem is that it depends on thin,
  # and thin breaks when starting this app. not sure why yet.
  # gem 'apiary'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'faker'
end

group :test do
  gem 'rspec', '~> 3.0.0'
  gem 'rspec-rails', '~> 3.0.0'
  gem 'capybara', github: 'jnicklas/capybara', branch: '2.2_stable'
  # gem "nyan-cat-formatter"
  gem 'database_cleaner'
  gem 'shoulda-matchers', require: false
  gem 'timecop'
  gem 'webmock'
end

# Use debugger
# gem 'debugger', group: [:development, :test]

