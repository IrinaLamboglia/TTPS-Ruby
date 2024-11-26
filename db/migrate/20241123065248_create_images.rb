class CreateImages < ActiveRecord::Migration[8.0]
  def change
    unless table_exists?(:images)
      create_table :images do |t|
        t.integer :product_id, null: false
        t.timestamps
      end
    end
  end
end
