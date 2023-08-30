class ArticlesController < ApplicationController
    def index
        @articles = Article.all
    end
    # showアクション＝特定の記事を表示する
    # 特定の記事のURLは「/articles/123」みたいなやつ
    # そのGETリクエストを受け取ると、paramsが生成され、そのidを↓で取得したいからparam[:id]
    def show
        @article = Article.find(params[:id])
    end

    def new
        @article = Article.new
    end

    def create
        # article_paramsの内容をarticleインスタンスに持たせる（持たせるだけなので↓でDBに保存する）
        @article = Article.new(article_params)
        # DBに保存させる（保存したらそのページに飛ぶ）
        if @article.save
            redirect_to article_path(@article), notice:"保存できたよ"
        else
            flash.now[:error] = "保存に失敗しました"
            # 保存されなかったら、new.html.erbを表示する
            render :new
        end
    end

    private
    # 投稿した内容からtitleとcontentを抜き出してくれる
    def article_params
        # strong parameter   paramsが、articleキーを持っていて、tilteとcontentだけを保存の対象とする
        params.require(:article).permit(:title, :content)
    end
end