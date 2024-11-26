class CreateRolePermissions < ActiveRecord::Migration[8.0]
  def change
    unless table_exists?(:role_permissions)
      create_table :role_permissions do |t|
        t.integer :role_id, null: false
        t.integer :permission_id, null: false
        t.timestamps
      end
    end
  end
end
