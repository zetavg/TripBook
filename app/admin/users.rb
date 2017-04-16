# frozen_string_literal: true
ActiveAdmin.register User do
  menu priority: 2

  actions :all, except: [:new, :create, :destroy]

  member_action :go_sign_in, method: :get do
    sign_in(:user, resource)
    redirect_to root_path, flash: { info: "用 #{resource.email} 的身分登入成功" }
  end

  scope :all, default: true

  filter :username
  filter :name
  filter :email
  filter :created_at
  filter :last_sign_in_at

  permit_params :name, :username

  action_item :sign_in, only: :show do
    link_to I18n.t("admin.users.sign_in_as_this_user"), go_sign_in_admin_user_path(user), target: :_blank
  end

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
    column :last_sign_in_at
    column :created_at
    column :actions do |user|
      link_to I18n.t("admin.users.sign_in_as_this_user"), go_sign_in_admin_user_path(user), target: :_blank
    end

    actions
  end

  show do
    attributes_table do
      row :id
      row :email

      row :name
      row :username

      row :created_at
      row :updated_at
    end

    if resource.facebook_account.present?
      panel I18n.t("models.attributes.user.facebook_account") do
        attributes_table_for resource.facebook_account do
          row :facebook_id do |facebook_account|
            link_to facebook_account.facebook_id, facebook_account.url, target: '_blank'
          end
          row :email
          row :name
          row :created_at
          row :updated_at
        end
      end
    end

    if resource.versions.any?
      panel I18n.t("admin.general.recent_changes") do
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

    panel I18n.t("admin.general.actions") do
      para do
        link_to I18n.t("admin.users.sign_in_as_this_user"), go_sign_in_admin_user_path(user), target: :_blank
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
