require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq' if Rails.env.development?
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # to:は省略可　rootはルートドメインにアクセスしたときに表示するページの指定
  # getは後ろにパス指定できるが、ルートできない
  root to: 'articles#index'
  # /が来たら、homeのindex（= HomeControllerのindexメソッド）を実行する
  # get '/' => 'home#index'



  # ルーティング表にいろんなpathが作成される
  resources :articles

  # accounts/:id/followsというURLができる
  resources :accounts, only: [:show] do
    resources :follows, only: [:create]
    resources :unfollows, only: [:create]
  end

  
  scope module: :apps do
    resources :favorites, only:[:index]
    resource :profile, only:[:show, :edit, :update]
    resource :timeline, only: [:show]
  end
    
  # namespaceでURLとコントローラを変えたけどURLだけにidをつけたい
  namespace :api, defaults: {format: :json} do
    scope '/articles/:article_id' do
      resources :comments, only: [:index, :create]
      resource :like, only: [:show, :create, :destroy]
    end
  end

end