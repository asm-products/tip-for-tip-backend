class AddUuidToPerks < ActiveRecord::Migration
  def change
    add_column :perks, :uuid, :string, null: false, unique: true, limit: 36
    add_index :perks, :uuid
  end
end
