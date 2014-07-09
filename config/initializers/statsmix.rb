StatsMix.api_key = Rails.application.secrets.statsmix['api_key']
StatsMix.ignore unless Rails.env.production?
StatsMix.ignore if StatsMix.api_key.nil?
