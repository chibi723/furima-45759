class Order < ApplicationRecord
  # データベースの関連性
  # 1対多の関係の「多」側 (購入者)
  belongs_to :user
  
  # 1対1の関係 (購入された商品)
  belongs_to :item 
  
  # 1対1の関係 (配送先情報)
  has_one :address
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  #devise :database_authenticatable, :registerable,:recoverable, :rememberable, :validatable
end
