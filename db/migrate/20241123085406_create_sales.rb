class CreateSales < ActiveRecord::Migration[8.0]
  def change
    create_table :sales do |t|
      t.datetime :date
      t.decimal :total
      t.references :employee, null: false, foreign_key: true
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
