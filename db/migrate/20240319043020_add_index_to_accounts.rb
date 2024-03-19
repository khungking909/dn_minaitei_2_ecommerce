class AddIndexToAccounts < ActiveRecord::Migration[7.1]
  def change
    add_index :accounts, :email,unique: true
  end
end
