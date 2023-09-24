Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # to:は省略可　rootはルートドメインにアクセスしたときに表示するページの指定
  # getは後ろにパス指定できるが、ルートできない
  root to: 'articles#index'
  # /が来たら、homeのindex（= HomeControllerのindexメソッド）を実行する
  # get '/' => 'home#index'

  resource :timeline, only: [:show]

  # ルーティング表にいろんなpathが作成される
  resources :articles do
    resources :comments, only: [:index, :new, :create]
    resource :like, only: [:show, :create, :destroy]
  end

  # accounts/:id/followsというURLができる
  resources :accounts, only: [:show] do
    resources :follows, only: [:create]
    resources :unfollows, only: [:create]
  end

  resource :profile, only:[:show, :edit, :update]
  resources :favorites, only:[:index]
end
