class OrderAddress
  include ActiveModel::Model

  attr_accessor :token, :postal_code, :prefecture_id, :city,
                :addresses, :building, :phone_number, :user_id, :product_id

  # 必須項目のバリデーション
  with_options presence: true do
    validates :token
    validates :postal_code
    validates :prefecture_id
    validates :city
    validates :addresses
    validates :phone_number
    validates :user_id
    validates :product_id
  end

  # 郵便番号
  validates :postal_code,
            format: {
              with: /\A\d{3}-\d{4}\z/,
            }

  # 都道府県（1は '--'）
  validates :prefecture_id,
            numericality: { other_than: 1 }

  # 電話番号
  validates :phone_number,
            format: {
              with: /\A\d{10,11}\z/,
            }

  def save
    sanitize_input
    return false unless valid?

    order = Order.create!(
      user_id: user_id,
      product_id: product_id
    )

    Address.create!(
      postal_code: postal_code,
      prefecture_id: prefecture_id,
      city: city,
      addresses: addresses,
      building: building,
      phone_number: phone_number,
      order_id: order.id
    )
  end

  private

  def sanitize_input
    # 郵便番号の整形
    if self.postal_code.present?
      # 全角数字を半角に変換
      self.postal_code = self.postal_code.tr('０-９', '0-9')
      # 数字とハイフン以外を削除
      self.postal_code = self.postal_code.delete("^0-9-")
      # 8文字まで（ただし、バリデーションで形式チェックされるため、ここでは主に整形に注力）
      self.postal_code = self.postal_code.slice(0, 8) if self.postal_code.length > 8
    end

    # 電話番号の整形
    if self.phone_number.present?
      # 全角数字を半角に変換
      self.phone_number = self.phone_number.tr('０-９', '0-9')
      # 数字以外を削除
      self.phone_number = self.phone_number.delete("^0-9")
      # 11桁まで
      self.phone_number = self.phone_number.slice(0, 11) if self.phone_number.length > 11
    end
  end
end
