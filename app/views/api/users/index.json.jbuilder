# frozen_string_literal: true
json.array! @users, partial: 'api/users/user_simple', as: :user
