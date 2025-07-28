module Users
    class SubscriptionsController < ApplicationController
      before_action :authenticate_user!
  
      def create
        plan = params[:plan]
        token = params[:stripe_token]
  
        Stripe::SubscriptionCreator.new(current_user, plan, token).call
  
        if current_user.may_activate_subscription?
          current_user.activate_subscription!
        end
  
        redirect_to articles_path, notice: "Subscription activated successfully!"
      rescue => e
        redirect_to user_profile_path, alert: "Subscription failed: #{e.message}"
      end
    end
  end
  