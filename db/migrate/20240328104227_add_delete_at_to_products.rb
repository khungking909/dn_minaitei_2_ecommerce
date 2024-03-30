class AddDeleteAtToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :is_deleted, :boolean, default: false
  end
end
