module Api
    module V1
      class ArticlesController < ApplicationController
        def index
          articles = Article.all
          render json: articles
        end
  
        def show
          article = Article.find(params[:id])
          render json: article
        end
  
        def create
          article = Article.new(article_params)
          article.user_id = params[:user_id]
  
          if article.save
            render json: article, status: :created
          else
            render json: { errors: article.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        private
  
        def article_params
          params.require(:article).permit(:title, :body)
        end
      end
    end
  end
  