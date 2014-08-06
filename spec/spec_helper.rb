ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'shoulda/matchers'
require 'capybara/rails'
require 'capybara/rspec'
require 'sidekiq/testing'
require 'webmock/rspec'
require 'factory_girl'

Rails.application.routes.default_url_options[:host] = 'local.tipfortip.com'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  # Nyan!
  # config.formatter = NyanFormatter

  config.expect_with :rspec do |c|
    # disable the `should` syntax
    c.syntax = :expect
  end

  config.before(:each) do
    Rails.cache.clear
  end

  # rspec-rails 3 will no longer automatically infer an example group's spec type
  # from the file location. You can explicitly opt-in to this feature using this
  # snippet:
  config.infer_spec_type_from_file_location!

  WebMock.disable_net_connect!(allow_localhost: true)

  config.mock_with :rspec do |c|
    c.yield_receiver_to_any_instance_implementation_blocks = true
  end
end
