class AddUrlToImages < ActiveRecord::Migration[8.0]
  def change
    add_column :images, :url, :string
  end
end
