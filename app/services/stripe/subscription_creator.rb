module Stripe
    class SubscriptionCreator
      def initialize(user, plan, token)
        @user = user
        @plan = plan
        @token = token
      end
  
      def call
        raise ArgumentError, "Invalid plan" unless plan_price_id(@plan)
  
        customer = ::Stripe::Customer.create({
          name: @user.username,
          source: @token
        })
  
        subscription = ::Stripe::Subscription.create({
          customer: customer.id,
          items: [{ price: plan_price_id(@plan) }]
        })
  
        @user.create_subscription!(
          plan: @plan,
          stripe_subscription_id: subscription.id,
          status: subscription.status
        )
  
        @user.update!(
        stripe_customer_id: customer.id,
        role: role_for_plan(@plan)
        )

      rescue ::Stripe::CardError => e
        raise e
      end
  
      private
  
      def plan_price_id(plan)
        {
          'basic' => 'price_1Ro16ARVoPRB0pETGwMSNvp1',
          'professional' => 'price_1Ro16hRVoPRB0pETftzTuNoh',
          'elite' => 'price_1Ro17KRVoPRB0pETd9NgrFBQ'
        }[plan]
      end
  
      def role_for_plan(plan)
        {
          'basic' => 'normal_user',
          'professional' => 'editor',
          'elite' => 'admin'
        }[plan]
      end
    end
  end
  