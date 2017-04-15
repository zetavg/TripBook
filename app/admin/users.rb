# frozen_string_literal: true
ActiveAdmin.register User do
  menu priority: 2

  actions :all, except: [:new, :create, :destroy]

  member_action :go_sign_in, method: :get do
    sign_in(:user, resource)
    redirect_to root_path, flash: { info: "用 #{resource.email} 的身分登入成功" }
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

    if resource.versions.any?
      panel 'Recent Changes' do
        table_for resource.versions.reorder(created_at: :desc).limit(100) do
          column :created_at do |version|
            link_to l(version.created_at), [:admin, version], target: '_blank'
          end
          column :event do |version|
            status_tag_class = case version.event
                               when 'create'
                                 'ok'
                               when 'update'
                                 'yes'
                               else
                                 'orange'
                               end
            status_tag(version.event, class: status_tag_class)
          end
          column :operator do |version|
            if version.operator.present?
              link_to [:admin, version.operator], target: '_blank' do
                status_tag_class = version.operator.class.name == 'User' ? 'yes' : 'orange'
                status_tag(version.operator.class.name, class: status_tag_class)
                version.operator.email
              end
            end
          end
          column :changeset do |version|
            pre JSON.pretty_generate(version.changeset)
          end
        end
      end
    end

    panel 'Actions' do
      para do
        link_to 'Sign in as this user', go_sign_in_admin_user_path(user), target: :_blank
      end
    end
  end

  action_item :sign_in, only: :show do
    link_to "Sign in", go_sign_in_admin_user_path(user), target: :_blank
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
