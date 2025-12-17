require 'rails_helper'

RSpec.describe "Orders", type: :request do
  before do
    @user = FactoryBot.create(:user)
    @product = FactoryBot.create(:product)
    @order_address_params = {
      token: "tok_test_123",
      order_address: {
        postal_code: "123-4567",
        prefecture_id: 2,
        city: "横浜市",
        addresses: "1-1-1",
        building: "テストビル",
        phone_number: "09012345678"
      }
    }
  end

  describe "POST /products/:product_id/orders" do
    context "ログインしていて、購入情報が正しいとき" do
      before do
        sign_in @user

        # PayJPをモック（実通信しない）
        allow(Payjp::Charge).to receive(:create).and_return(double("charge"))
      end

      it "Order と Address が保存される" do
        expect {
          post product_orders_path(@product), params: @order_address_params
        }.to change(Order, :count).by(1)
         .and change(Address, :count).by(1)
      end

      it "トップページへリダイレクトされる" do
        post product_orders_path(@product), params: @order_address_params
        expect(response).to redirect_to(root_path)
      end
    end

    context "ログインしていても、購入情報が不正なとき" do
      before do
        sign_in @user
      end

      it "tokenが空だと購入できない" do
        invalid_params = @order_address_params.deep_merge(token: "")

        expect {
          post product_orders_path(@product), params: invalid_params
        }.not_to change(Order, :count)

        expect(response).to have_http_status(:unprocessable_content)

      end

      it "postal_codeが不正だと購入できない" do
        invalid_params = @order_address_params.deep_merge(
          order_address: { postal_code: "1234567" }
        )

        expect {
          post product_orders_path(@product), params: invalid_params
        }.not_to change(Order, :count)
      end

      it "phone_numberがハイフン付きだと購入できない" do
        invalid_params = @order_address_params.deep_merge(
          order_address: { phone_number: "090-1234-5678" }
        )

        expect {
          post product_orders_path(@product), params: invalid_params
        }.not_to change(Order, :count)
      end
    end

    context "ログインしていないとき" do
      it "ログインページへリダイレクトされる" do
        post product_orders_path(@product), params: @order_address_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "売却済み商品を購入しようとしたとき" do
      before do
        sign_in @user
        allow(Payjp::Charge).to receive(:create).and_return(double("charge"))

        # 先に購入済みにする
        Order.create!(user: @user, product: @product)
      end

      it "購入画面へ遷移できずトップへ戻される" do
        post product_orders_path(@product), params: @order_address_params
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
