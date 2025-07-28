Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get "users/show"
  devise_for :users, controllers: {
  registrations: 'users/registrations',
  sessions: 'users/sessions',
  confirmations: 'users/confirmations'
}

  namespace :users do
    resource :addresses, only: [:new, :create]
    resources :subscriptions, only: [:create]
  end

  authenticated :user do
    root to: 'articles#index', as: :authenticated_root
  end

  unauthenticated do
    devise_scope :user do
      root to: 'users/registrations#new', as: :unauthenticated_root
    end
  end

  resources :articles do
    resources :comments, only: [:create, :destroy]
    resource :like, only: [:create]
  end
  
  get '/profile', to: 'users#show', as: 'user_profile'
  
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  
end
