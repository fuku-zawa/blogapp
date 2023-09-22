class TimelinesController < ApplicationController
  before_action :authenticate_user!
  
  def show
    # followingで取得できたidをすべて取得する（配列が入る）
    user_ids = current_user.followings.pluck(:id)
    @articles = Article.where(user_id: user_ids)
  end
end