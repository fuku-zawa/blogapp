# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
require 'rails_helper'

# 「タイトルが入力されている場合」とタイトルの文字が１文字の場合の２パターン
RSpec.describe Article, type: :model do
  # userは共通なのでcontextの外側で変数を定義
  let!(:user) { create(:user) }

  context 'タイトルと内容が入力されている場合'do
    let!(:article)  { build(:article, user: user) }

    it '記事を保存できる' do
      expect(article).to be_valid
    end
  end

  context 'タイトルの文字が1文字の場合' do
    # buildではなくcreateにすると、ここでエラーが発生してitまでいけなくなる
    let!(:article)  { build(:article, title: Faker::Lorem.characters(number: 1), user: user) }

    # エラーメッセージはcreateやsaveしたときに取得できる
    before do
      article.save
    end

    it '記事を保存できない' do
      expect(article.errors.messages[:title][0]).to eq('は2文字以上で入力してください')
    end

  end

end
