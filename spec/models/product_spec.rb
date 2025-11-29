require 'rails_helper'

RSpec.describe Product, type: :model do
  before do
    @product = FactoryBot.build(:product)
  end

  describe '商品の出品' do
    context '出品できるとき' do
      it '全ての値が正しく入力されていれば保存できる' do
        expect(@product).to be_valid
      end
    end

    context '出品できないとき' do
      it 'imageが空では保存できない' do
        @product.image = nil
        @product.valid?
        expect(@product.errors.full_messages).to include("画像 を添付してください")
      end

            it 'nameが空では保存できない' do
        @product.name = ''
        @product.valid?
        expect(@product.errors.full_messages).to include("商品名 を入力してください")
      end

      it 'infoが空では保存できない' do
        @product.info = ''
        @product.valid?
        expect(@product.errors.full_messages).to include("商品の説明 を入力してください")
      end

      it 'category_idが1では保存できない' do
        @product.category_id = 1
        @product.valid?
        expect(@product.errors.full_messages).to include("カテゴリー を選択してください")
      end

      it 'sales_status_idが1では保存できない' do
        @product.sales_status_id = 1
        @product.valid?
        expect(@product.errors.full_messages).to include("商品の状態 を選択してください")
      end

      it 'shipping_fee_status_idが1では保存できない' do
        @product.shipping_fee_status_id = 1
        @product.valid?
        expect(@product.errors.full_messages).to include("配送料の負担 を選択してください")
      end

      it 'prefecture_idが1では保存できない' do
        @product.prefecture_id = 1
        @product.valid?
        expect(@product.errors.full_messages).to include("発送元の地域 を選択してください")
      end

      it 'scheduled_delivery_idが1では保存できない' do
        @product.scheduled_delivery_id = 1
        @product.valid?
        expect(@product.errors.full_messages).to include("発送までの日数 を選択してください")
      end

      it 'priceが空では保存できない' do
        @product.price = ''
        @product.valid?
        expect(@product.errors.full_messages).to include("価格 を入力してください")
      end

      it 'priceが300未満では保存できない' do
        @product.price = 100
        @product.valid?
        expect(@product.errors.full_messages).to include("価格 は300以上の値にしてください")
      end

      it 'priceが9,999,999より大きいと保存できない' do
        @product.price = 10_000_000
        @product.valid?
        expect(@product.errors.full_messages).to include("価格 は9999999以下の値にしてください")
      end

      it 'priceが半角数値でないと保存できない（全角数字）' do
        @product.price = '１２３４'
        @product.valid?
        expect(@product.errors.full_messages).to include("価格 は数値で入力してください")
      end

      it 'priceが数値でないと保存できない（文字列など）' do
        @product.price = 'aaaa'
        @product.valid?
        expect(@product.errors.full_messages).to include("価格 は数値で入力してください")
      end

      it 'userが紐付いていないと保存できない' do
        @product.user = nil
        @product.valid?
        expect(@product.errors.full_messages).to include("User を入力してください")
      end
    end
  end
end
