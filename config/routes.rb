# frozen_string_literal: true
Rails.application.routes.draw do
  root 'pages#index'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  authenticate :user do
    namespace :me do
      resources :owned_books
    end
  end

  namespace :api, defaults: { format: :json } do
    resources :book_infos, only: [:index]
    resources :book_info_cover_images, only: [:create]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
