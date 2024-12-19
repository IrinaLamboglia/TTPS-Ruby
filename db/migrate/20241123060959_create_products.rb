class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price, null: false
      t.integer :stock, null: false, default: 0
      t.string :color
      t.string :size
      t.integer :category_id, null: false
      t.datetime :deleted_at
      t.timestamps
    end

    # Agregar restricción de verificación para asegurar que el stock no sea negativo
    execute <<-SQL
      ALTER TABLE products
      ADD CONSTRAINT check_stock_non_negative
      CHECK (stock >= 0);
    SQL
  end
end