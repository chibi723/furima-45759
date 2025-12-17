require "rails_helper"

RSpec.describe OrderAddress, type: :model do
  before do
    user = create(:user)
    product = create(:product)
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
        expect(@order_address.errors.full_messages).to include("クレジットカード情報 を入力してください")
      end

      it "postal_codeが空だと無効" do
        @order_address.postal_code = ""
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include("郵便番号 を入力してください")
      end

      it "postal_codeが不正な形式だと無効" do
        @order_address.postal_code = "1234567"
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include("郵便番号 はハイフンを含んだ半角数字で正しく入力してください")
      end

      it "prefecture_idが1だと無効" do
        @order_address.prefecture_id = 1
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include("都道府県 を入力してください")
      end

      it "cityが空だと無効" do
        @order_address.city = ""
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include("市区町村 を入力してください")
      end

      it "addressesが空だと無効" do
        @order_address.addresses = ""
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include("番地 を入力してください")
      end

      it "phone_numberが空だと無効" do
        @order_address.phone_number = ""
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include("電話番号 を入力してください")
      end

      it "phone_numberがハイフン付きだと無効" do
        @order_address.phone_number = "090-1234-5678"
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include("電話番号 はハイフンなしの10桁または11桁の半角数字で入力してください")
      end

      it "phone_numberが9桁以下だと無効" do
        @order_address.phone_number = "090123456"
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include("電話番号 はハイフンなしの10桁または11桁の半角数字で入力してください")
      end

      it "phone_numberが12桁以上だと無効" do
        @order_address.phone_number = "090123456789"
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include("電話番号 はハイフンなしの10桁または11桁の半角数字で入力してください")
      end

      it 'user_idが空では保存できない' do
        @order_address.user_id = nil
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include("ユーザー を入力してください")
      end

      it 'product_idが空では保存できない' do
        @order_address.product_id = nil
        @order_address.valid?
        expect(@order_address.errors.full_messages).to include("商品 を入力してください")
      end
    end
  end
end
