class AddFoursquareIdToPlaces < ActiveRecord::Migration
  def change
    add_column :nouns_places, :foursquare_id, :string
    add_index :nouns_places, :foursquare_id
  end
end
