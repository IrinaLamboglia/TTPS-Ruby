class CreateSaleItems < ActiveRecord::Migration[8.0]
  def change
      create_table :sale_items do |t|
        t.integer :sale_id, null: false
        t.integer :product_id, null: false
        t.integer :quantity, null: false
        t.decimal :price, null: false
        t.timestamps
      end
  end
end
