class ApplicationController < ActionController::Base
  include Pundit::Authorization
  allow_browser versions: :modern
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # def authenticate_admin_user!
  #   authenticate_admin_user! unless current_admin_user
  # end
  
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      case resource.status
      when "unverified"
        root_path
      when "pending_address"
        new_users_addresses_path
      when "pending_address_approval", "start_subscription"
        user_profile_path
      when "active"
        articles_path
      else
        root_path
      end
    else
      super
    end
  end
  
end
