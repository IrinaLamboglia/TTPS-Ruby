class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.integer :stock
      t.string :color
      t.string :size
      t.references :category, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps # Esto ya crea created_at y updated_at
    end
  end
end
