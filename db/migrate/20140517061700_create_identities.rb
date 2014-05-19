class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.references :user
      t.string :uid
      t.string :provider
      t.string :token
      t.datetime :token_expires_at
      t.text :profile_data

      t.timestamps
    end

    add_index :identities, :user_id
    add_index :identities, :provider
  end
end
