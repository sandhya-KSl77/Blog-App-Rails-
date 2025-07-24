class UserMailer < ApplicationMailer
    default from: 'sandhya.varma@ksolves.com'
  
    def welcome_email(user)
      @user = user
      mail(to: @user.email, subject: 'Welcome to My Blogging App!')
    end
  end
  