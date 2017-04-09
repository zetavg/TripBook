# frozen_string_literal: true
class UserSelectionInput < SimpleForm::Inputs::Base
  include Rails.application.routes.url_helpers

  def input(_wrapper_options = nil)
    value = object.try(attribute_name)
    user = object.try(attribute_name.to_s.gsub(/_id$/, ''))
    preload_user_ids = case options[:preload_user_ids]
                       when Array
                         options[:preload_user_ids].join(',')
                       else
                         options[:preload_user_ids]
                       end

    template.content_tag :div, class: 'user-selection-input', data: {
      api_users_path: api_users_path,
      preload_user_ids: preload_user_ids,
      value: value,
      user_username: user&.username,
      user_name: user&.name,
      user_picture_url: user&.picture&.image&.small&.url
    } do
      template.concat @builder.select(attribute_name, {}, {}, data: { user_id_select: true }, style: 'width: 100%;')
    end
  end
end
