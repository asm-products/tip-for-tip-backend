class CreateUsers < ActiveRecord::Migration
  def change

    create_table :users do |t|

      t.string :uuid, unique: true
      t.string :username, unique: true

      t.string :first_name
      t.string :last_name

      t.string :email, unique: true

      t.string :timezone
      t.string :locale

      t.datetime :last_login_at
      t.datetime :last_request_at

      t.timestamps
    end

    add_index :users, :uuid
    add_index :users, :username
    add_index :users, :email

  end
end
