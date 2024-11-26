class CreateSaleItems < ActiveRecord::Migration[8.0]
  def change

    unless table_exists?(:sale_items)
      create_table :sale_items do |t|
        t.integer :sale_id, null: false
        t.integer :product_id, null: false
        t.integer :quantity
        t.decimal :price
        t.timestamps
      end
    end
  end
end
