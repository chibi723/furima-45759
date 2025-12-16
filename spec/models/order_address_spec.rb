require "rails_helper"

RSpec.describe OrderAddress, type: :model do
  before do
    user = build(:user)
    product = build(:product)
    @order_address = build(
      :order_address,
      user_id: user.id,
      product_id: product.id
    )
  end

  describe "購入情報の保存" do
    context "保存できるとき" do
      it "全て正しく入力されていれば有効" do
        expect(@order_address).to be_valid
      end

      it "buildingは空でも有効" do
        @order_address.building = ""
        expect(@order_address).to be_valid
      end
    end

    context "保存できないとき" do
      it "tokenが空だと無効" do
        @order_address.token = ""
        @order_address.valid?
        expect(@order_address.errors.full_messages.join).to include("can't be blank")
      end

      it "postal_codeが空だと無効" do
        @order_address.postal_code = ""
        @order_address.valid?
        expect(@order_address.errors.full_messages.join).to include("can't be blank")
      end

      it "postal_codeが不正な形式だと無効" do
        @order_address.postal_code = "1234567"
        @order_address.valid?
        expect(@order_address.errors.full_messages.join).to include("is invalid")
      end

      it "prefecture_idが1だと無効" do
        @order_address.prefecture_id = 1
        @order_address.valid?
        expect(@order_address.errors.full_messages.join).to include("can't be blank")
      end

      it "cityが空だと無効" do
        @order_address.city = ""
        @order_address.valid?
        expect(@order_address.errors.full_messages.join).to include("can't be blank")
      end

      it "addressesが空だと無効" do
        @order_address.addresses = ""
        @order_address.valid?
        expect(@order_address.errors.full_messages.join).to include("can't be blank")
      end

      it "phone_numberが空だと無効" do
        @order_address.phone_number = ""
        @order_address.valid?
        expect(@order_address.errors.full_messages.join).to include("can't be blank")
      end

      it "phone_numberがハイフン付きだと無効" do
        @order_address.phone_number = "090-1234-5678"
        @order_address.valid?
        expect(@order_address.errors.full_messages.join).to include("is invalid")
      end

      it "phone_numberが9桁以下だと無効" do
        @order_address.phone_number = "090123456"
        @order_address.valid?
        expect(@order_address.errors.full_messages.join).to include("is invalid")
      end

      it "phone_numberが12桁以上だと無効" do
        @order_address.phone_number = "090123456789"
        @order_address.valid?
        expect(@order_address.errors.full_messages.join).to include("is invalid")
      end
    end
  end
end
