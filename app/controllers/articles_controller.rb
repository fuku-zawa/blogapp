class ArticlesController < ApplicationController

    before_action :set_article, only:[:show]
    before_action :authenticate_user!, only:[:new, :create, :edit, :update, :destroy]

    def index
        @articles = Article.all
    end
    # showアクション＝特定の記事を表示する
    # 特定の記事のURLは「/articles/123」みたいなやつ
    # そのGETリクエストを受け取ると、paramsが生成され、そのidを↓で取得したいからparam[:id]
    def show

    end

    def new
        @article = current_user.articles.build
    end

    def create
        # article_paramsの内容をarticleインスタンスに持たせる（持たせるだけなので↓でDBに保存する）
        @article = current_user.articles.build(article_params)
        # DBに保存させる（保存したらそのページに飛ぶ）
        if @article.save
            redirect_to article_path(@article), notice:'保存できたよ'
        else
            flash.now[:error] = '保存に失敗しました'
            # 保存されなかったら、new.html.erbを表示する
            render :new
        end
    end

    def edit
        @article = current_user.articles.find(params[:id])
    end

    def update
        @article = current_user.articles.find(params[:id])
        if @article.update(article_params)
            redirect_to article_path(@article), notice: '更新できました'
        else
            flash.now[:erroe] = '更新できませんでした'
            render :edit
        end
    end

    def destroy
        article = current_user.articles.find(params[:id])
        article.destroy!
        redirect_to root_path, notice: '削除に成功しました'
    end

    private
    # 投稿した内容からtitleとcontentを抜き出してくれる
    def article_params
        # strong parameter   paramsが、articleキーを持っていて、tilteとcontentだけを保存の対象とする
        params.require(:article).permit(:title, :content, :eyecatch)
    end

    def set_article
        @article = Article.find(params[:id])
    end

end
