class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      # 外部キー: 出品者 (Userモデル)
      t.references :user,                 null: false, foreign_key: true

      # Itemモデルに必要なカラム
      t.string     :name,                 null: false
      t.text       :info,                 null: false
      t.integer    :price,                null: false
      
      # ActiveHashで使用する外部キー（integer型）
      t.integer    :category_id,          null: false
      t.integer    :sales_status_id,      null: false
      t.integer    :shipping_fee_id,      null: false
      t.integer    :prefecture_id,        null: false
      t.integer    :scheduled_delivery_id,null: false

      t.timestamps
    end
  end
end