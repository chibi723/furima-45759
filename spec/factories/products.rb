FactoryBot.define do
  factory :product do
    name                  { "テスト商品" }
    info                  { "テスト商品説明" }
    category_id           { 2 }
    sales_status_id       { 2 }
    shipping_fee_status_id{ 2 }
    prefecture_id         { 2 }
    scheduled_delivery_id { 2 }
    price                 { 1000 }

    association :user

    after(:build) do |product|
      product.image.attach(
        io: File.open(Rails.root.join('spec/images/test_image.png')),
        filename: 'test_image.png',
        content_type: 'image/png'
      )
    end
  end
end
