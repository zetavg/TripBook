# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :admins, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # root 'pages#index'
  root 'book_infos#index'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :book_infos, path: 'books',
                         only: [:index, :show],
                         param: :isbn do
    scope module: :book_infos do
      authenticate :user do
        resource :borrow_demand, path: 'borrow-demand',
                                 only: [:create] do
          scope module: :borrow_demands do
            resource :cancellation, only: [:create]
          end
        end
      end
    end
  end

  authenticate :user do
    namespace :me do
      resources :invitations, only: [:index] do
        scope module: :invitations do
          resource :acception, only: [:create]
          resource :rejection, only: [:create]
        end
      end
      resources :sent_invitations, only: [:index], path: 'sent-invitations' do
        scope module: :sent_invitations do
          resources :invitation_users, only: [:new, :create] do
            scope module: :invitation_users do
              resource :cancellation, only: [:create]
            end
          end
        end
      end

      resources :books do
        scope module: :books do
          resources :borrowing_invitations, path: 'borrowing-invitations', only: [:index, :new, :create] do
            resource :cancellation, only: [:create], module: :borrowing_invitations
          end

          resource :reading, path: 'reading', only: [:new, :create]
        end
      end

      resources :owned_books, path: 'owned-books' do
        resources :borrowing_trips, path: 'borrowing-trips',
                                    only: [:new, :create, :show, :edit, :update] do
          scope module: :book_borrowing_trips do
            resource :cancellation, only: [:create]
            resource :returnation, only: [:create]
          end
        end
      end
    end
  end

  namespace :api, defaults: { format: :json } do
    resources :users, path: 'users', only: [:index]
    resources :book_infos, path: 'book-infos', only: [:index]
    resources :book_info_cover_images, path: 'book-info-cover-images', only: [:create]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
