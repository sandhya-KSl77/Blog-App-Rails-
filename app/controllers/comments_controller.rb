class CommentsController < ApplicationController
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
      @comment.destroy
      redirect_to article_path(@article)
    end
  
    private
  
    def comment_params
      params.require(:comment).permit(:body)
    end    
  end
  