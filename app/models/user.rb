class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # アソシエーション
  has_many :items    # 出品した商品
  has_many :orders   # 購入した商品

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  #devise :database_authenticatable, :registerable,:recoverable, :rememberable, :validatable

  with_options presence: true do
    # ニックネーム
    validates :nickname
    
    # 本人確認情報（氏名、カナ）
    with_options format: { with: /\A[ぁ-んァ-ヶ一-龥々ー]+\z/, message: 'は全角（漢字・ひらがな・カタカナ）で入力してください' } do
      validates :last_name
      validates :first_name
    end
    
    with_options format: { with: /\A[ァ-ヶー]+\z/, message: 'は全角（カタカナ）で入力してください' } do
      validates :last_name_kana
      validates :first_name_kana
    end
    
    # 生年月日
    validates :birthday
  end
  
  # パスワードのバリデーション
  # パスワードは6文字以上で、英字と数字の両方を含む
  validates :password, format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i, message: 'は英字と数字を両方含む6文字以上で設定してください' }
end
