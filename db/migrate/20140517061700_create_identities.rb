class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|

      t.references :user
      t.string :uid
      t.string :provider
      t.datetime :token_expires_at
      t.text :profile_data

      t.timestamps
    end
  end
end
