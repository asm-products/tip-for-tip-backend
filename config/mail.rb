# ActionMailer::Base.smtp_settings = {
#     address:   => "smtp.mandrillapp.com",
#     port:      => 587,
#     user_name: => Rails.application.secrets.mandrill['username'],
#     password:  => Rails.application.secrets.mandrill['password'],
#     domain:    => 'tipfortip.com'
#   }
# ActionMailer::Base.delivery_method = :smtp

MandrillMailer.configure do |config|
  config.api_key = Rails.application.secrets.mandrill['api_key']
end
