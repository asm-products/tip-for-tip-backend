class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.string   :service
      t.text     :receipt_data
      t.text     :encoded_receipt_data
      t.string   :transaction_id
      t.datetime :transaction_timestamp
      t.boolean  :verified
      t.string   :unverified_reason

      t.references :tip
      t.references :user

      t.timestamps
    end

    add_index :purchases, :service
    add_index :purchases, :transaction_id
    add_index :purchases, :tip_id
    add_index :purchases, :user_id
  end
end
