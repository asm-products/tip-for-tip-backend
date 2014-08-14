mode = Rails.env.production? ? 'live' : 'sandbox'

PayPal::SDK.configure(
  mode: mode,
  app_id:    Rails.application.secrets.paypal['app_id'],
  username:  Rails.application.secrets.paypal['username'],
  password:  Rails.application.secrets.paypal['password'],
  signature: Rails.application.secrets.paypal['signature']
)
