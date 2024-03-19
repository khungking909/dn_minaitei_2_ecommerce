class CreateOrderHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :order_histories do |t|
      t.integer :order_id
      t.integer :product_id
      t.integer :quantity
      t.integer :current_price

      t.timestamps
    end
  end
end
