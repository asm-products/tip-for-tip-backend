class CreateNounsPersons < ActiveRecord::Migration
  def change
    create_table :nouns_persons do |t|
      t.string :uuid, null: false, unique: true
      t.string :name, null: false
      t.timestamps
    end

    add_index :nouns_persons, :uuid
    add_index :nouns_persons, :name
  end
end
