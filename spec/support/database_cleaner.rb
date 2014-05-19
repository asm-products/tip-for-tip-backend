require 'database_cleaner'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation
    DatabaseCleaner.strategy = :transaction
  end

  # config.around(:each) do |spec|
  #   if spec.metadata[:js]
  #     spec.run
  #     DatabaseCleaner.clean_with :truncation
  #   else
  #     DatabaseCleaner.start
  #     spec.run
  #     DatabaseCleaner.clean
  #   end
  # end
end
