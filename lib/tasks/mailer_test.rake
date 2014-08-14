namespace :mailer_test do |args|

  desc "Test the welcome mailer"
  task welcome: :environment do |t, args|
    user = nil
    user = User.find_by(email: ENV['EMAIL']) if ENV['EMAIL']
    user = User.find(ENV['USER_ID']) if user.nil? && ENV['USER_ID']
    raise "Either an EMAIL or USER_ID env variable is required. " unless user
    UserLifecycleMailer.welcome(user).deliver
    puts "User welcome email delivered to #{user.email} (#{user.full_name})"
  end

end
