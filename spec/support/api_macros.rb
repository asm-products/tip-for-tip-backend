module Support
  module ApiMacros

    def accept_json
      request.env["HTTP_ACCEPT"] = 'application/json'
    end

  end
end

RSpec.configure do |config|
  config.include Support::ApiMacros, type: :controller
end
