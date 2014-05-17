class CreateUsers < ActiveRecord::Migration
  def change

    create_table :users do |t|

      t.string :uuid,     null: false, unique: true
      t.string :username, null: false, unique: true
      t.string :email,    null: false, unique: true

      t.string :first_name
      t.string :last_name

      t.string :timezone
      t.string :locale

      t.datetime :last_request_at

      t.timestamps
    end

    add_index :users, :uuid,     unique: true
    add_index :users, :username, unique: true
    add_index :users, :email,    unique: true

  end
end
