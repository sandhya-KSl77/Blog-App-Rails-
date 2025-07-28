class Users::AddressesController < ApplicationController
    before_action :authenticate_user!
  
    def new
      redirect_to articles_path, alert: "You're already approved." and return if current_user.active?
      @address = current_user.addresses.build
    end
  
    def create
      @address = current_user.addresses.build(address_params)
      @address.address_type = "billing"
  
      if @address.save
        current_user.submit_address!
        UserMailer.with(user: current_user).address_pending.deliver_later
        redirect_to user_profile_path, notice: "Address submitted. Awaiting admin approval."
      else
        render :new
      end
    end
  
    private
  
    def address_params
      params.require(:address).permit(:line1, :line2, :city, :zip)
    end
  end
  