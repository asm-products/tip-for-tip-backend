class AssociationsToSupportAccountingSystem < ActiveRecord::Migration
  def change

    add_column :users, :customer_account_id, :integer
    add_index  :users, :customer_account_id

    add_column :purchases, :purchase_entry_id, :integer
    add_index  :purchases, :purchase_entry_id

  end
end
