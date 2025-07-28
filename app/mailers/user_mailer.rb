class UserMailer < ApplicationMailer
  default from: 'sandhya.varma@ksolves.com'

  def welcome_email
    @user = params[:user]
    mail(to: @user.email, subject: 'Welcome to My Blogging App!')
  end

  def address_pending
    @user = params[:user]
    mail(to: @user.email, subject: "Your address is submitted and pending approval")
  end

  def submit_address_reminder
    @user = params[:user]
    mail(to: @user.email, subject: "Please submit your address to continue")
  end
end
