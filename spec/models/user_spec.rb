require 'rails_helper'

RSpec.describe User, type: :model do
  # テストデータの生成を簡略化するため、build_stubbedを使用
  before do
    @user = build(:user)
  end

  describe 'ユーザー新規登録' do
    context '新規登録できるとき' do
      it 'すべての必須項目が正しく入力されていれば登録できる' do
        expect(@user).to be_valid
      end

      # パスワードの半角英数字混合の要件を満たすテスト
      it 'passwordとpassword_confirmationが6文字以上の半角英数字混合であれば登録できる' do
        @user.password = 'a123456'
        @user.password_confirmation = 'a123456'
        expect(@user).to be_valid
      end
    end

    context '新規登録できないとき' do
      # ----------------------------------------------------
      # 1. Deviseデフォルトのバリデーション (必須要件の検証)
      # ----------------------------------------------------

      it 'nicknameが空では登録できない' do
        @user.nickname = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("ニックネーム を入力してください")
      end

      it 'emailが空では登録できない' do
        @user.email = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("メールアドレス を入力してください")
      end

      it '重複したemailが存在する場合は登録できない' do
        @user.save
        another_user = FactoryBot.build(:user, email: @user.email)
        another_user.valid?
        expect(another_user.errors.full_messages).to include("メールアドレス は既に使用されています")
      end

      it 'emailに@を含まない場合は登録できない' do
        @user.email = 'testmail.com'
        @user.valid?
        expect(@user.errors.full_messages).to include("メールアドレス は不正な値です")
      end

      it 'passwordが空では登録できない' do
        @user.password = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワード を入力してください")
      end

      it 'passwordが5文字以下では登録できない' do
        @user.password = 'a1234'
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワード は6文字以上で入力してください")
      end

      it 'passwordとpassword_confirmationが不一致では登録できない' do
        @user.password_confirmation = 'mismatched'
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワード（確認） とパスワードの入力が一致しません")
      end

      # ----------------------------------------------------
      # 2. カスタムバリデーション (英数字混合、氏名、カナ、生年月日)
      # ----------------------------------------------------

      # パスワード関連
      it 'passwordが英字のみでは登録できない' do
        @user.password = 'aaaaaa'
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワード（確認） とパスワードの入力が一致しません", "パスワード は英字と数字を両方含む6文字以上で設定してください")
      end

      it 'passwordが数字のみでは登録できない' do
        @user.password = '111111'
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワード（確認） とパスワードの入力が一致しません", "パスワード は英字と数字を両方含む6文字以上で設定してください")
      end

      it 'passwordに全角文字が含まれると登録できない' do
        @user.password = 'a1234あ'
        @user.valid?
        expect(@user.errors.full_messages).to include("パスワード（確認） とパスワードの入力が一致しません", "パスワード は英字と数字を両方含む6文字以上で設定してください")
      end

      # 本人情報（氏名）関連
      it 'last_nameが空では登録できない' do
        @user.last_name = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("姓 を入力してください", "姓 は全角（漢字・ひらがな・カタカナ）で入力してください")
      end
      it 'first_nameが空では登録できない' do
        @user.first_name = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("名 を入力してください", "名 は全角（漢字・ひらがな・カタカナ）で入力してください")
      end
      it 'last_nameが全角（漢字・ひらがな・カタカナ）以外では登録できない' do
        @user.last_name = 'Smith'
        @user.valid?
        expect(@user.errors.full_messages).to include("姓 は全角（漢字・ひらがな・カタカナ）で入力してください")
      end
      it 'first_nameが全角（漢字・ひらがな・カタカナ）以外では登録できない' do
        @user.first_name = 'John'
        @user.valid?
        expect(@user.errors.full_messages).to include("名 は全角（漢字・ひらがな・カタカナ）で入力してください")
      end

      # 本人情報（カナ）関連
      it 'last_name_kanaが空では登録できない' do
        @user.last_name_kana = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("姓（カナ） を入力してください", "姓（カナ） は全角（カタカナ）で入力してください")
      end
      it 'first_name_kanaが空では登録できない' do
        @user.first_name_kana = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("名（カナ） を入力してください", "名（カナ） は全角（カタカナ）で入力してください")
      end
      it 'last_name_kanaが全角カタカナ以外では登録できない' do
        @user.last_name_kana = 'やまだ'
        @user.valid?
        expect(@user.errors.full_messages).to include("姓（カナ） は全角（カタカナ）で入力してください")
      end
      it 'first_name_kanaが全角カタカナ以外では登録できない' do
        @user.first_name_kana = 'たろう'
        @user.valid?
        expect(@user.errors.full_messages).to include("名（カナ） は全角（カタカナ）で入力してください")
      end

      # 生年月日関連
      it 'birth_dateが空では登録できない' do
        @user.birth_date = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("生年月日 を入力してください")
      end
    end
  end
end