class UserLifecycleMailer < MandrillMailer::TemplateMailer
  default from: 'support@tipfortip.com', from_name: "Tip for Tip"

  def welcome user
    i18n_scope = 'user_lifecycle_mailer.welcome'

    mandrill_mail template: 'welcome',
      subject: I18n.t(:subject, scope: i18n_scope),
      to: { email: user.email, name: user.full_name },
      recipient_vars: [
        user.email => {
          "EMAIL" => user.email,
          "FULL_NAME" => user.full_name,
          "FIRST_NAME" => user.first_name,
          "LAST_NAME" => user.last_name
          # location
        }
      ]
  end

  def self.deliver_async mailer, user_id
    UserLifecycleMailerWorker.perform_async mailer, user_id
  end
end
