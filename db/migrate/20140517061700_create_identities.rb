class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|

      t.references :user
      t.string :provider
      t.text :access_token
      t.datetime :token_expires_at
      t.text :profile_data

      t.timestamps
    end
  end
end
