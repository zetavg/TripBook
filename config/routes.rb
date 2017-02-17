# frozen_string_literal: true
Rails.application.routes.draw do
  root 'pages#index'

  devise_for :users,
             controllers: {
               omniauth_callbacks: 'users/omniauth_callbacks'
             }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
