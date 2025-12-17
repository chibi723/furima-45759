FactoryBot.define do
  factory :order_address, class: "OrderAddress" do
    token         { "tok_test_#{SecureRandom.hex(8)}" } # 使い回しNG対策
    postal_code   { "123-4567" }
    prefecture_id { 2 }
    city          { "横浜市" }
    addresses     { "1-1-1" }
    building      { "" }
    phone_number  { "09012345678" }

    transient do
      user { create(:user) }
      product { create(:product) }
    end
  end
end
