class CreatePermissions < ActiveRecord::Migration[8.0]
  def change
    create_table :permissions do |t|
      t.string :name

      t.timestamps
    end
    add_index :permissions, :name, unique: true
  end
end
