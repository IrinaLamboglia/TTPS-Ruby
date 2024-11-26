class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    unless table_exists?(:categories)
      create_table :categories do |t|
        t.string :name
        t.timestamps
      end
    end
  end
end
