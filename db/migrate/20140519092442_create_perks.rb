class CreatePerks < ActiveRecord::Migration
  def change

    create_table :perks do |t|
      t.references :subscription, null: false
      t.string :title, null: false
      t.timestamps
    end

    add_index :perks, :subscription_id

  end
end
