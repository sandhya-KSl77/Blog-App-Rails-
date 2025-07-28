ActiveAdmin.register User do
    permit_params :username, :email, :role, :status, :confirmed_at
  
    # ===== Index =====
    index do
      selectable_column
      id_column
      column :email
      column :username
      column("Confirmed?") { |user| user.confirmed? ? "Yes" : "No" }
      column :status
      column :created_at
      actions
    end
  
    # ===== Show Page =====
    show do
      attributes_table do
        row :id
        row :email
        row :username
        row :role
        row("Confirmed?") { |user| user.confirmed? ? "Yes" : "No" }
        row :status
        row :created_at
        row :updated_at
      end
    end
  
    # ===== Filters =====
    filter :email
    filter :username
    filter :role
    filter :status
    filter :confirmed_at
    filter :created_at
  
    # ===== Sidebar Buttons =====
  
    sidebar "User Workflow", only: :show do
        attributes_table_for resource do
          row :status
          row("Confirmed?") { resource.confirmed? ? "Yes" : "No" }
        end
      
        if !resource.confirmed? || resource.may_verify_email?
          div do
            link_to "Verify Email", confirm_and_verify_admin_user_path(resource), method: :put, class: 'button'
          end
        end
      
        if resource.may_submit_address?
          div do
            link_to "Submit Address", submit_address_admin_user_path(resource), method: :put, class: 'button'
          end
        end
      
        if resource.may_approve_address?
          div do
            link_to "Approve Address", approve_address_admin_user_path(resource), method: :put, class: 'button'
          end
        end
      
        if resource.may_activate_subscription?
          div do
            link_to "Activate Subscription", start_subscription_admin_user_path(resource), method: :put, class: 'button'
          end
        end
      end
      
  
    # ===== Member Actions =====
  
    member_action :confirm_and_verify, method: :put do
        unless resource.confirmed?
          resource.update!(confirmed_at: Time.current)
        end
        resource.verify_email! if resource.may_verify_email?
        redirect_to admin_user_path(resource), notice: "User confirmed and state set to pending_address."
      end

      member_action :submit_address, method: :put do
        if resource.addresses.exists?
          resource.submit_address!
          redirect_to admin_user_path(resource), notice: "User state moved to pending_address_approval."
        else
          redirect_to admin_user_path(resource), alert: "User has not submitted an address yet."
        end
      end
      
      member_action :approve_address, method: :put do
        resource.approve_address!
        redirect_to admin_user_path(resource), notice: "User state moved to start_subscription."
      end
       
      member_action :start_subscription, method: :put do
        if resource.stripe_customer_id.present?
          if resource.may_activate_subscription?
            resource.activate_subscription!
            redirect_to admin_user_path(resource), notice: "User is now active."
          else
            redirect_to admin_user_path(resource), alert: "Cannot activate from current state."
          end
        else
          redirect_to admin_user_path(resource), alert: "Stripe subscription not found. Cannot activate."
        end
      end      
  end
  