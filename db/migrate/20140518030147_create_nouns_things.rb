class CreateNounsThings < ActiveRecord::Migration
  def change
    create_table :nouns_things do |t|
      t.string :uuid,     null: false, unique: true, limit: 36
      t.string :name, null: false
      t.timestamps
    end

    add_index :nouns_things, :uuid, unique: true
    add_index :nouns_things, :name
  end
end
