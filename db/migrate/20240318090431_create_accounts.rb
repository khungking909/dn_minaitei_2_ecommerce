class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :email
      t.integer :role
      t.string :address
      t.string :phone_number
      t.string :password_digest
      t.string :remember_digest

      t.timestamps
    end
  end
end
