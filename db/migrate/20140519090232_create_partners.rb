class CreatePartners < ActiveRecord::Migration
  def change

    add_column :users, :partner_id, :integer
    add_index :users, :partner_id

    create_table :partners do |t|
      t.references :primary_user
      t.timestamps
    end

    add_index :partners, :primary_user_id

  end
end
