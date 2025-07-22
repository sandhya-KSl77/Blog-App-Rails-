class LikesController < ApplicationController
    before_action :authenticate_user!
  
    def create
        @article = Article.find(params[:article_id])
        @like = @article.likes.find_or_initialize_by(user: current_user)
        @like.like_type = params[:like_type]
      
        if @like.save
          @article.reload
          @user_like = @article.likes.find_by(user: current_user)
      
          respond_to do |format|
            format.turbo_stream
            format.html { redirect_to @article }
          end
        else
          head :unprocessable_entity
        end
      end      
  end
  