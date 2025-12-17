require 'payjp'
class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: [:index, :create]
  before_action :move_to_root, only: [:index, :create]

  def index
    @order_address = OrderAddress.new
  end

  def create
    @order_address = OrderAddress.new(order_address_params)
    if @order_address.valid?
      pay_item
      @order_address.save
      redirect_to root_path
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def order_address_params
    params.require(:order_address).permit(
      :postal_code, :prefecture_id, :city, :addresses,
      :building, :phone_number
    ).merge(
      user_id: current_user.id,
      product_id: @product.id,
      token: params[:token]
    )
  end

  # アクセス制御
  def move_to_root
    # 出品者 or 売却済み の場合トップへ
    if current_user.id == @product.user_id || @product.sold_out?
      redirect_to root_path
    end
  end

  # PAY.JP決済
  def pay_item
    Payjp.api_key = Rails.application.credentials.payjp[:secret_key]

    Payjp::Charge.create(
      amount: @product.price,
      card: order_address_params[:token],
      currency: 'jpy'
    )
  end
end
