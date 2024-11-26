class CreateSales < ActiveRecord::Migration[8.0]
  def change
    unless table_exists?(:sales)
      create_table :sales do |t|
        t.datetime :date
        t.decimal :total
        t.references :employee, null: false, foreign_key: { to_table: :users }
        t.references :customer, null: false, foreign_key: { to_table: :users }

        t.timestamps
      end
    end
  end
end
