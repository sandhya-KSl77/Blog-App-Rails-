class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  def new
    build_resource({})
    resource.addresses.build(address_type: :billing)
    resource.addresses.build(address_type: :mailing)
    respond_with resource
  end

  def edit
    if resource.addresses.empty?
      resource.addresses.build(address_type: :billing)
      resource.addresses.build(address_type: :mailing)
    end
    super
  end

  def create
    build_resource(sign_up_params)
  
    resource.save
    yield resource if block_given?
  
    if resource.persisted?
      if params[:user][:plan].present? && params[:user_stripe_token].present?
        begin
          Stripe::SubscriptionCreator.new(resource, params[:user][:plan], params[:user_stripe_token]).call
        rescue Stripe::CardError => e
          flash[:alert] = e.message
          resource.destroy
          redirect_to new_user_registration_path and return
        end
      end
  
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end  

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :username, :name, :avatar, :plan,
      addresses_attributes: [:id, :line1, :line2, :city, :zip, :address_type, :_destroy]
    ])
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :username, :name, :avatar, :role,
      addresses_attributes: [:id, :line1, :line2, :city, :zip, :address_type, :_destroy]
    ])
  end

  def sign_up_params
    super.merge(plan: params[:user][:plan])
  end
end
