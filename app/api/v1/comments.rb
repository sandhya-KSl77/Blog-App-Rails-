module API
    module V1
      class Comments < Grape::API
        helpers AuthHelpers
  
        resource :articles do
          route_param :article_id do
            resource :comments do
  
              desc 'List comments for article'
              get do
                article = Article.find(params[:article_id])
                article.comments
              end
  
              desc 'Add comment (auth required)'
              params do
                requires :content, type: String
              end
              post do
                authenticate!
                article = Article.find(params[:article_id])
                comment = article.comments.new(body: params[:content], user: current_user)
                if comment.save
                  { message: 'Comment added', comment: comment }
                else
                  error!(comment.errors.full_messages, 422)
                end
              end
  
              desc 'Delete comment (auth required)'
              delete ':id' do
                authenticate!
                comment = Comment.find(params[:id])
                if comment.user_id == current_user.id
                  comment.destroy
                  { message: 'Comment deleted' }
                else
                  error!('Unauthorized to delete this comment', 403)
                end
              end
            end
          end
        end
      end
    end
  end
  