Rails.application.routes.draw do
  devise_for :users

  root to: 'items#index'   # トップページ（一覧）

  resources :products, only: [:index, :new, :create]
end
