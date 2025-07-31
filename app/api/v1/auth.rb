module API
    module V1
      class Auth < Grape::API
        resource :auth do
          desc 'User signup'
          params do
            requires :username, type: String
            requires :email, type: String
            requires :password, type: String
            requires :password_confirmation, type: String
          end
          post :signup do
            user = User.new(declared(params))
            if user.save
              status 201
              { message: 'Signup successful' }
            else
              error!(user.errors.full_messages, 422)
            end
          end
  
          desc 'User login'
          params do
            requires :email, type: String
            requires :password, type: String
          end
          post :login do
            user = User.find_by(email: params[:email])
            if user&.valid_password?(params[:password])
              token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
              { token: token, user: { id: user.id, email: user.email, username: user.username } }
            else
              error!('Invalid email or password', 401)
            end
          end
        end
      end
    end
  end
  