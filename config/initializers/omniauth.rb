OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do

  # Facebook
  facebook_secrets = Rails.application.secrets.facebook
  provider :facebook, facebook_secrets[:client_id], facebook_secrets[:client_secret]

  # Twitter

  # Oauth

  # Developer

end
