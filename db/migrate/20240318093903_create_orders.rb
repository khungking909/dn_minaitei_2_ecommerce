class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.integer :account_id
      t.integer :status
      t.string :receiver_name
      t.string :receiver_address
      t.string :receiver_phone_number

      t.timestamps
    end
  end
end
