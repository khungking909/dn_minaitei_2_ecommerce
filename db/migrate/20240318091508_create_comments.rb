class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.integer :account_id
      t.integer :product_id
      t.string :content
      t.integer :parent_id
      t.integer :rating

      t.timestamps
    end
  end
end
