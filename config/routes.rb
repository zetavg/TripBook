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

  resources :book_infos, path: 'books', only: [:index, :show], param: :isbn

  authenticate :user do
    namespace :me do
      resources :books
      resources :owned_books, path: 'owned-books' do
        resources :borrowing_trips, path: 'borrowing-trips', only: [:new, :create, :show, :edit, :update] do
          scope module: :book_borrowing_trips do
            resource :cancellation, only: [:create]
            resource :returnation, only: [:create]
          end
        end
      end
    end
  end

  namespace :api, defaults: { format: :json } do
    resources :book_infos, path: 'book-infos', only: [:index]
    resources :book_info_cover_images, path: 'book-info-cover-images', only: [:create]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
