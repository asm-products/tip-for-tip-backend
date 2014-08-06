require 'mandrill_mailer/offline'

RSpec.configure do |config|
  config.before :each do
    MandrillMailer.deliveries.clear
  end
end
