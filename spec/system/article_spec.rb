require 'rails_helper'

RSpec.describe 'Article', type: :system do
  # chatgptのコード
  before do
    # Capybaraのドライバー設定を変更する
    driven_by :selenium, using: :headless_chrome
  end

  let!(:user) { create(:user) }
  let!(:articles) { create_list(:article, 3, user: user) }

  it '記事一覧が表示される' do
    # capybaraのメソッド:root_pathを開く
    visit root_path
    articles.each do |article|
      expect(page).to have_css('.card_title', text: article.title)
    end
  end

  it '記事詳細を表示できる' do
    visit root_path
    article = articles.first
    click_on articles.first.title
    expect(page).to have_css('.article_title', text: article.title)
    expect(page).to have_css('.article_content', text: article.content.to_plain_text)
  end
end