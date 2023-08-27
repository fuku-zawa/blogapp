Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
#  /が来たら、homeのindex（= HomeControllerのindexメソッド）を実行する
  get '/' => 'home#index'
  get "/about" => "home#about"
end
