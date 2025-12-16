class OrderAddress
  include ActiveModel::Model

  attr_accessor :token, :postal_code, :prefecture_id, :city,
                :addresses, :building, :phone_number, :user_id, :product_id

  # 各種バリデーション（既にあるもの）
  validates :token, presence: true
  # 1. 郵便番号のバリデーション
  # 必須入力
  validates :postal_code, presence: true
  # 形式: 半角数字3桁-半角数字4桁 (例: 123-4567)
  validates :postal_code, format: { with: /\A\d{3}-\d{4}\z/, message: "はハイフンを含んだ半角数字で正しく入力してください" }

  validates :prefecture_id, presence: true, numericality: { other_than: 1 }
  validates :city, presence: true
  validates :addresses, presence: true
  # 2. 電話番号のバリデーション
  # 必須入力
  validates :phone_number, presence: true
  # 形式: ハイフンなしの半角数字10桁または11桁 (JSのロジックに合わせ11桁までを許容)
  validates :phone_number, format: { with: /\A\d{10,11}\z/, message: "はハイフンなしの10桁または11桁の半角数字で入力してください" }

  def save
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
