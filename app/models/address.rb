class Address < ApplicationRecord
  # データベースの関連性
  # 1対1の関係の「多」側 (注文情報)
  belongs_to :order
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  #devise :database_authenticatable, :registerable,:recoverable, :rememberable, :validatable
end
