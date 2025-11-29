class Product < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  # ActiveHash のアソシエーション
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :sales_status
  belongs_to :shipping_fee_status
  belongs_to :prefecture
  belongs_to :scheduled_delivery

  # バリデーション
  validates :image, presence: true
  validates :name, presence: true
  validates :info, presence: true
  validates :price, presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 300,
              less_than_or_equal_to: 9_999_999
            }

  validates :category_id, :sales_status_id, :shipping_fee_status_id,
            :prefecture_id, :scheduled_delivery_id,
            numericality: { other_than: 1 }
end
