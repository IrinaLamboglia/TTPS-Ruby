class CreateRoles < ActiveRecord::Migration[8.0]
  def change
    unless table_exists?(:roles)
      create_table :roles do |t|
        t.string :name
        t.timestamps
      end
    end
    unless index_exists?(:roles, :name, unique: true)
      add_index :roles, :name, unique: true
    end
  end
end
