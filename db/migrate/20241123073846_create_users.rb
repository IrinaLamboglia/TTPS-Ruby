class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    
      create_table :users do |t|
        t.string :username
        t.string :email
        t.string :phone
        t.string :encrypted_password, default: "", null: false
        t.string :role, null: false
        t.date :join_date
        t.boolean :active, default: true
        t.datetime :renember_created_at

        t.timestamps
      end
      add_index :users, :username, unique: true
      add_index :users, :email, unique: true
  end
end
