class CreateTips < ActiveRecord::Migration
  def change

    create_table :tips do |t|
      t.string :uuid, null: false, unique: true, limit: 36

      t.string :subject, null: false
      t.text   :body, null: false

      t.references :user
      t.references :noun, polymorphic: true

      t.boolean :is_annonymous
      t.boolean :can_purchase_with_reputation

      t.boolean :sent
      t.timestamp :send_at

      t.timestamps
    end

    add_index :tips, :uuid, unique: true
    add_index :tips, :sent
    add_index :tips, :user_id
    add_index :tips, [:noun_id, :noun_type]

  end
end
