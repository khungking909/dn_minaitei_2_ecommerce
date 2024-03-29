class AddMessageToOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :message, :string
  end
end
