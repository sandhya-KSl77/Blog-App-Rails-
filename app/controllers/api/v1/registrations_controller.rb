module Api
    module V1
      class RegistrationsController < Devise::RegistrationsController
        skip_before_action :verify_authenticity_token
        respond_to :json
  
        def create
          build_resource(sign_up_params)
  
          resource.status = 'unverified'
          resource.save
  
          if resource.persisted?
            render json: { message: 'Registered successfully.' }, status: :created
          else
            render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        private
  
        def sign_up_params
          params.require(:user).permit(:username, :email, :password, :password_confirmation)
        end
      end
    end
  end
  