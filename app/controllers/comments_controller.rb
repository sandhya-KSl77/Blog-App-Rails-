class CommentsController < ApplicationController
    before_action :authenticate_user!

    def create
      @article = Article.find(params[:article_id])
      @comment = @article.comments.build(comment_params)
      @comment.user = current_user 
    
      if @comment.save
        redirect_to @article, notice: "Comment posted successfully."
      else
        render "articles/show"
      end
    end
  
    def destroy
      @article = Article.find(params[:article_id])
      @comment = @article.comments.find(params[:id])
      authorize @comment
      if @comment.destroy
        redirect_to article_path(@article), notice: "Comment deleted."
      else
        redirect_to article_path(@article), alert: "Failed to delete comment."
      end
    end
  
    private
  
    def comment_params
      params.require(:comment).permit(:body)
    end    
  end
  