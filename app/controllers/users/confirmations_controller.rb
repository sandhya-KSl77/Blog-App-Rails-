class Users::ConfirmationsController < Devise::ConfirmationsController
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      resource.verify_email! if resource.may_verify_email?
      sign_in(resource_name, resource)
      redirect_to user_profile_path, notice: "Email confirmed! Please complete your registration."
    else
      render :new
    end
  end
end
