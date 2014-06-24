class CreateIapReceiptVerifications < ActiveRecord::Migration
  def up
    remove_column :purchases, :receipt_data
    remove_column :purchases, :encoded_receipt_data
    remove_column :purchases, :verified
    remove_column :purchases, :unverified_reason

    create_table :iap_receipt_verifications do |t|
      t.references :user
      t.boolean  :successful
      t.string   :transaction_id
      t.string   :result
      t.string   :result_message
      t.string   :service
      t.text     :encoded_receipt_data
      t.text     :receipt_data
      t.text     :request_metadata
      t.timestamps
    end

    add_index :iap_receipt_verifications, :user_id
    add_index :iap_receipt_verifications, :transaction_id
    add_index :iap_receipt_verifications, :successful
    add_index :iap_receipt_verifications, :result
    add_index :iap_receipt_verifications, :result_message

    add_column :purchases, :iap_receipt_verification_id, :integer

  end

  def down
    drop_table :iap_receipt_verifications
    add_column :purchases, :receipt_data, :text
    add_column :purchases, :encoded_receipt_data, :text
    remove_column :purchases, :iap_receipt_verification_id
    add_column :purchases, :verified, :boolean
    add_column :purchases, :unverified_reason, :string
  end
end
