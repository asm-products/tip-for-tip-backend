StatsMix.api_key = Rails.application.secrets.statsmix['api_key'] || 'none'
StatsMix.ignore = true unless Rails.env.production?
