module Support
  module Mandrill
    include WebMock::API

    def stub_mandrill
      stub_request(:post, "https://mandrillapp.com/api/1.0/messages/send-template.json")
        .to_return(:status => 200, :body => "", :headers => {})
    end

  end
end
