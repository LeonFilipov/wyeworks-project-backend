class ArticlesController < ApplicationController
    before_action :set_article, only: [:show, :update, :destroy, :publish]

  # GET /articles
  def index
    @articles = Article.all
    render json: @articles
  end

  # GET /articles/:id
  def show
    render json: @article
  end

  # POST /articles
  def create
    @article = Article.new(article_params)
    if @article.save
      render json: @article, status: :created, location: @article
      #render status: :created, location: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # POST /articles/:id/publish
  def publish
    # Example logic to mark the article as published
    @article.update(published: true)
    puts(@article)
    render json: { message: 'Article published successfully', article: @article }
  end

  # PATCH/PUT /articles/:id
  def update
    if @article.update(article_params)
      render json: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # DELETE /articles/:id
  def destroy
    @article.destroy
  end

  private
    def set_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :body)
    end
end
