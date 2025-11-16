class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :user,   null: false, foreign_key: true  # 購入者ID
      t.references :item,   null: false, foreign_key: true, index: false # 商品ID (1対1)

      t.timestamps
    end
    add_index :orders, :item_id, unique: true
  end
end