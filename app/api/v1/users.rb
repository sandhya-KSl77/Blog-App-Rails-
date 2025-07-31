module API
    module V1
      class Users < Grape::API
        resource :users do
  
          desc 'List users'
          get do
            users = User.all
            present users, with: Entities::UserEntity
          end
  
          desc 'Get a user'
          params do
            requires :id, type: Integer
          end
          get ':id' do
            user = User.find(params[:id])
            present user, with: Entities::UserEntity
          end
  
        end
      end
    end
  end
  