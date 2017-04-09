# frozen_string_literal: true
ActiveAdmin.register User do
  menu priority: 2

  actions :all, except: [:new, :create, :destroy]

  member_action :go_sign_in, method: :get do
    sign_in(:user, resource)
    redirect_to root_path
  end

  scope :all, default: true

  filter :name
  filter :email
  filter :created_at

  permit_params :name, :username

  index do
    selectable_column
    id_column

    column :name do |user|
      link_to user.name, admin_user_path(user)
    end
    column :username do |user|
      link_to user.username, admin_user_path(user)
    end
    column :email
    column :created_at
    column :actions do |user|
      link_to "Sign in", go_sign_in_admin_user_path(user), target: :_blank
    end

    actions
  end

  show do
    attributes_table do
      row :id
      row :email

      row :created_at
      row :updated_at
    end

    panel 'Actions' do
      para do
        link_to 'Sign in as this user', go_sign_in_admin_user_path(user), target: :_blank
      end
    end
  end

  form do |f|
    f.semantic_errors

    f.inputs do
      input :name
      input :username
    end

    f.actions
  end
end
