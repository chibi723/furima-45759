class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # アソシエーション
  # has_many :items    # 出品した商品
  # has_many :orders   # 購入した商品

  # ------------------------------------------------------------------
  # 必須項目およびフォーマットのバリデーション
  # ------------------------------------------------------------------
  with_options presence: true do
    # ニックネーム
    validates :nickname
    
    # 本人確認情報（氏名） - 存在チェックと全角フォーマット
    with_options format: { with: /\A[ぁ-んァ-ヶ一-龥々ー]+\z/, message: 'は全角（漢字・ひらがな・カタカナ）で入力してください' } do
      validates :last_name
      validates :first_name
    end
    
    # 本人確認情報（カナ氏名） - 存在チェックと全角カタカナフォーマット
    with_options format: { with: /\A[ァ-ヶー]+\z/, message: 'は全角（カタカナ）で入力してください' } do
      validates :last_name_kana
      validates :first_name_kana
    end
    
    # 生年月日
    validates :birth_date
  end
  
  validates :password, format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i, message: 'は英字と数字を両方含む6文字以上で設定してください' }, if: :password
end