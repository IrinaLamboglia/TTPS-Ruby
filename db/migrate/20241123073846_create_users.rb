class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    unless table_exists?(:users)
      create_table :users do |t|
        t.string :username
        t.string :email
        t.string :phone
        t.string "encrypted_password", default: "", null: false
        t.string :role
        t.date :join_date
        t.boolean :active

        t.timestamps
      end
    end
    unless index_exists?(:users, :username, unique: true)
      add_index :users, :username, unique: true
    end
    unless index_exists?(:users, :email, unique: true)
      add_index :users, :email, unique: true
    end
  end
end
