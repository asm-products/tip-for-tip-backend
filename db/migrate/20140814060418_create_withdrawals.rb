class CreateWithdrawals < ActiveRecord::Migration
  def change
    create_table :withdrawals do |t|
      t.decimal :amount, :precision => 20, :scale => 10
      t.references :user
      t.references :withdrawal_entry
      t.string :transaction_id
      t.text :paypal_response
      t.timestamps
    end

    add_index :withdrawals, :withdrawal_entry_id
    add_index :withdrawals, :transaction_id
  end
end
