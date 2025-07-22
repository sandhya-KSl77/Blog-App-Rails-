Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  authenticated :user do
    root to: 'articles#index', as: :authenticated_root
  end

  unauthenticated do
    devise_scope :user do
      root to: 'users/registrations#new', as: :unauthenticated_root
    end
  end

  resources :articles do
    resources :comments
    resource :like, only: [:create]
  end
end
