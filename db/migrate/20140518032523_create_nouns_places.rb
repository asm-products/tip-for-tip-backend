class CreateNounsPlaces < ActiveRecord::Migration
  def change
    create_table :nouns_places do |t|
      t.string :uuid, null: false, unique: true
      t.string :name, null: false

      t.float :latitude
      t.float :longitude

      t.text :foursquare_data

      t.timestamps
    end

    add_index :nouns_places, :uuid
    add_index :nouns_places, :name
    add_index :nouns_places, :latitude
    add_index :nouns_places, :longitude

  end
end
