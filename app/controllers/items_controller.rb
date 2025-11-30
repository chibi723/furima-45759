class ItemsController < ApplicationController
  def index
    # 出品された商品を新しい順に取得
    @products = Product.order(created_at: :desc)
  end
end
