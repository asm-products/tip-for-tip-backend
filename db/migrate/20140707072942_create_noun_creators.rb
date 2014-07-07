class CreateNounCreators < ActiveRecord::Migration
  def change
    create_table :noun_creators do |t|
      t.references :user
      t.references :noun, polymorphic: true
      t.timestamps
    end

    add_index :noun_creators, :user_id
    add_index :noun_creators, [:noun_type, :noun_id]
  end
end
