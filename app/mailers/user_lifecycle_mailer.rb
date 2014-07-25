# Note: This mailer scheme will be replaced by our notifications system later.
require 'mandrill'

class UserLifecycleMailer

  def self.welcome(user)
    template_name = "welcome"
    template_content = [{"name"=> user.full_name}]
    message = {
      to: [{ email: user.email, name: user.full_name, type: :to }]
    }
    async = true
    new user, template_name, template_content, message
  end

  # Instance methods

  def initialize(user, template, content, message)
    @user = user
    @template = template
    @content = content
    @message = message
  end

  def send!
    begin
      puts 'SENDING...'
      p @template
      p @content
      p @message
      result = mandrill.messages.send_template @template, @content, @message, true
    rescue Mandrill::Error => e
      # TODO: handle mandrill errors this way?
      logger.error "Unexpected server error, responding with 500: \n#{e.message}\n#{e.backtrace.join("\n")}"
      custom_data = { user_id: user.id, error: "#{e.class} - #{e.message}"}
      Rollbar.report_exception(e, custom_data)
    end
  end

  private

  def mandrill
    @mandrill ||= Mandrill::API.new(Rails.application.secrets.mandrill['api_key'])
  end
end
