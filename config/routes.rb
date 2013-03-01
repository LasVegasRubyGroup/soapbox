Soapbox::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  match '/auth/:provider/callback', to: 'authorizations#create'

  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new'
    get 'register', to: 'devise/registrations#new'
    delete 'sign_out', to: 'devise/sessions#destroy'
  end

  resources :topics do
    member do
      put :vote
      put :volunteer
    end
  end

  resources :meetings do
    member do
      put :finalize
    end
  end

  get 'recent', to: 'topics#recent'
  get 'leaderboard', to: 'info#leaderboard'

  root to: 'topics#index'
end
