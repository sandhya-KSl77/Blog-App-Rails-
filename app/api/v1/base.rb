require_relative 'auth'
require_relative 'articles'
require_relative 'comments'
require_relative 'users'

module API
  module V1
    class Base < Grape::API
      version 'v1', using: :path
      format :json

      mount API::V1::Auth
      mount API::V1::Articles
      mount API::V1::Comments
      mount API::V1::Users
    end
  end
end
