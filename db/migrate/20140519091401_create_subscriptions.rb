class CreateSubscriptions < ActiveRecord::Migration
  def change

    create_table :subscriptions do |t|
      t.references :partner, null: false
      t.references :noun, polymorphic: true, null: false
      t.timestamps
    end

    add_index :subscriptions, :partner_id
    add_index :subscriptions, [:noun_id, :noun_type]

  end
end
