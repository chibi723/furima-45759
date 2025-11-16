class Item < ApplicationRecord
  # ActiveHashのアソシエーション
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :sales_status # 商品の状態
  belongs_to :shipping_fee # 配送料の負担
  belongs_to :prefecture   # 発送元の地域
  belongs_to :scheduled_delivery # 発送までの日数

  # データベースのアソシエーション
  belongs_to :user      # 1対多の関係の「多」側 (出品者)
  has_one    :order     # 1対1の関係 (購入情報)

  with_options presence: true do
    validates :image
    validates :name
    validates :info
    validates :price, numericality: { only_integer: true, message: 'は半角数字で入力してください' },
                      # 300円から9,999,999円の間
                      inclusion: { in: 300..9_999_999, message: 'は¥300〜¥9,999,999の範囲で設定してください' }
    with_options numericality: { other_than: 1, message: "を選択してください" } do
      validates :category_id
      validates :sales_status_id
      validates :shipping_fee_id
      validates :prefecture_id
      validates :scheduled_delivery_id
    end
  end
end