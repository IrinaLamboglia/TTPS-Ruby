class CreatePermissions < ActiveRecord::Migration[8.0]
  def change
    unless table_exists?(:permissions)
      create_table :permissions do |t|
        t.string :name
        t.timestamps
      end
    end
    unless index_exists?(:permissions, :name, unique: true)
      add_index :permissions, :name, unique: true
    end
  end
end
