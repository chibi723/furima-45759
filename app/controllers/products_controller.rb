class ProductsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    # トップページの処理
    # 出品された商品を新しい順に取得
    @products = Product.order(created_at: :desc)
  end

  # 出品フォームを表示するためのアクション
  def new
    # ビューでフォームを構築するための空のインスタンス
    @product = Product.new
  end

  # フォームから送られたデータを保存するためのアクション
  def create
    @product = Product.new(product_params)
    
    # バリデーションチェックとデータベースへの保存
    if @product.save
      # 保存成功時：トップページへリダイレクト
      redirect_to root_path
    else
      # 保存失敗時：入力内容を保持したまま出品ページに戻す
      # status: :unprocessable_entity はエラー時の再描画に必要なステータス
      render :new, status: :unprocessable_entity
    end
  end

  private

  # 安全にデータを受け取るためのストロングパラメータ
  def product_params
    # permit: フォームで入力されたすべての属性とActiveHashのIDを許可
    # merge: フォームには含まれないuser_idをログインユーザーから取得して追加
    params.require(:product).permit(
      :image, 
      :name, 
      :info, 
      :category_id, 
      :sales_status_id, 
      :shipping_fee_status_id, 
      :prefecture_id, 
      :scheduled_delivery_id, 
      :price
    ).merge(user_id: current_user.id)
  end
end