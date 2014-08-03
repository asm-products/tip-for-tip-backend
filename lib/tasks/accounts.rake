namespace :accounts do
  desc "Ensures all users have a customer_account created for them."
  task create_customer_accounts: :environment do
    User.where(customer_account_id: nil).find_each do |user|
      unless user.customer_account
        puts "Creating a customer account for user #{user.id}"
        user.update_attributes! customer_account: CustomerAccount.create!(user: user)
      end
    end
  end
end
