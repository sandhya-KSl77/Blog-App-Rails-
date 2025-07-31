module Entities
    class ArticleEntity < Grape::Entity
      expose :id
      expose :title
      expose :body
      expose :comments
    end
  end
  