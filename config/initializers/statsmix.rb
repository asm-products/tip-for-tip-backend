StatsMix.api_key = Rails.application.secrets.statsmix['api_key']
StatsMix.ignore = true unless Rails.env.production?
StatsMix.ignore = true if StatsMix.api_key.nil?
