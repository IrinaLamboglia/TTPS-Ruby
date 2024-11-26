class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    unless table_exists?(:products)
      create_table :products do |t|
        t.string :name
        t.text :description
        t.decimal :price
        t.integer :stock
        t.string :color
        t.string :size
        t.integer :category_id, null: false
        t.datetime :deleted_at
        t.timestamps
      end
    end
  end
end
