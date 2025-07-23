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

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :username, :name, :avatar, :role,
      addresses_attributes: [:id, :line1, :line2, :city, :zip, :address_type, :_destroy]
    ])
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :username, :name, :avatar,:role,
      addresses_attributes: [:id, :line1, :line2, :city, :zip, :address_type, :_destroy]
    ])
  end
end
