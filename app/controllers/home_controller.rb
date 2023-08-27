class HomeController < ApplicationController
    def index
        @title = "デイトラ"
        # home/index.html.erbを表示する
        render 'home/index'
    end
    def about
        render "home/about"
    end
end