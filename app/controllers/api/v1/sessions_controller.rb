module Api
    module V1
      class SessionsController < Devise::SessionsController
        skip_before_action :verify_authenticity_token
        respond_to :json
  
        def create
          user = User.find_by(username: params[:user][:username])
  
          if user&.valid_password?(params[:user][:password])
            sign_in(resource_name, user)
  
            render json: {
              message: 'Logged in successfully',
              user: {
                id: user.id,
                email: user.email,
                username: user.username,
                status: user.status
              }
            }, status: :ok
          else
            render json: { error: 'Invalid username or password' }, status: :unauthorized
          end
        end
  
        def respond_to_on_destroy
          head :no_content
        end
      end
    end
  end
  