class ProductsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  before_action :set_product, only: [:show, :edit, :update]
  before_action :move_to_index, only: [:edit, :update]

  def index
    # トップページの処理
    # 新しい順で一覧表示
    @products = Product.order(created_at: :desc)
  end

  def show
    # @product は set_product で取得済み
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

  def edit
    # @product は set_product で取得済み
    # フォーム開いた時点で既存の情報が表示されればOK
  end

  def update
    if @product.update(product_params)
      # 更新成功 → 詳細ページへ戻る
      redirect_to product_path(@product)
    else
      # 更新失敗 → 編集ページに戻してエラーメッセージ表示
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  # 自分が出品した商品以外は編集させない
  def move_to_index
    redirect_to root_path unless current_user.id == @product.user_id
  end

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

  # 編集権限を制御する
  def move_to_index
    # 自分が出品した商品以外ならトップページへ
    redirect_to root_path if current_user.id != @product.user_id

    # ▼ 購入機能実装後に追加する
    # redirect_to root_path if @product.order.present?
  end
end