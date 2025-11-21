FactoryBot.define do
  factory :user do
    # Devise必須項目
    nickname              { 'テストニックネーム' }
    email                 { Faker::Internet.email }
    # 6文字以上の半角英数字混合を保証
    password              { 'a1' + Faker::Internet.password(min_length: 4) } 
    password_confirmation { password }
    
    # 追加カスタム項目
    last_name             { '山田' }
    first_name            { '太郎' }
    last_name_kana        { 'ヤマダ' }
    first_name_kana       { 'タロウ' }
    birth_date            { Faker::Date.birthday(min_age: 5, max_age: 90) }
  end
end