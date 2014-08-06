class UserLifecycleMailerWorker
  include Sidekiq::Worker
  sidekiq_options queue: :email, backtrace: true

  def perform(action, user_id)
    user = User.find user_id
    mail = UserLifecycleMailer.send action.to_sym, user
    mail.deliver
  end
end
