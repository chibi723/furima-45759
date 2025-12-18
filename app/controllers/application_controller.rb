class ApplicationController < ActionController::Base
  before_action :basic_auth, :configure_permitted_parameters, if: :devise_controller?

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]  # 環境変数を読み込む記述に変更
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :first_name, :last_name, :first_name_kana, :last_name_kana, :birth_date])
  end

  # ログイン・新規登録成功後のリダイレクト先
  def after_sign_in_path_for(resource)
    root_path # トップページへ遷移
  end

  # ログアウト成功後のリダイレクト先
  def after_sign_out_path_for(resource)
    root_path # トップページへ遷移
  end
end
