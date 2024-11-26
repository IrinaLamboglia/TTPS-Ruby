class AddRoleToUsers < ActiveRecord::Migration[8.0]
  def change
    unless column_exists?(:users, :role_id)
      add_reference :users, :role, null: false, foreign_key: true
    end    
  end
end
