class CreateSales < ActiveRecord::Migration[8.0]
  def change
      create_table :sales do |t|
        t.datetime :date, null: false
        t.decimal :total, null: false
        t.references :employee, null: false, foreign_key: { to_table: :users }
        t.references :customer, null: false, foreign_key: { to_table: :users }

        t.timestamps
      end
  end
end
