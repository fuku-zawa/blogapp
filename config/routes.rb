Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # to:は省略可　rootはルートドメインにアクセスしたときに表示するページの指定
  # getは後ろにパス指定できるが、ルートできない
  root to: "articles#index"
  # /が来たら、homeのindex（= HomeControllerのindexメソッド）を実行する
  # get '/' => 'home#index'
  
  # ルーティング表にいろんなpathが作成される
  resources :articles, only: [:show]
  
end
