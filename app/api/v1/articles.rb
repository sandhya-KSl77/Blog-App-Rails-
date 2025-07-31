module API
    module V1
      class Articles < Grape::API
        helpers AuthHelpers
  
        resource :articles do
          desc 'Return list of articles',
               is_array: true,
               entity: Entities::ArticleEntity
          get do
            authenticate!
            articles = Article.all
            present articles, with: Entities::ArticleEntity
          end
  
          desc 'Create a new article (requires authentication)'
          params do
            requires :title, type: String
            requires :body, type: String
          end
          post do
            authenticate! 
            article = current_user.articles.create!(
              title: params[:title],
              content: params[:body]
            )
            present article, with: Entities::ArticleEntity
          end
        end
      end
    end
  end
  