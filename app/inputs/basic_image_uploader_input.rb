# frozen_string_literal: true
class BasicImageUploaderInput < SimpleForm::Inputs::Base
  include Rails.application.routes.url_helpers

  IMAGE_INPUT_FIELD_HTML = <<-EOF.strip_heredoc
    <div class="add-image">
      <input
        type=\"file\"
        accept=\"image/jpg,image/jpeg,image/gif,image/png\"
        form=""
        data-upload-input="ture"
        multiple
      >
    </div>
  EOF

  def input(_wrapper_options = nil)
    thumbnail_size = options[:thumbnail_size] || 'thumbnail'
    object.try("build_#{attribute_name}") if object.try(attribute_name).blank?
    image_model = object.try(attribute_name)
    image_model_name = image_model.class.name.underscore.tr('/', '_')

    template.content_tag :div, class: 'basic_image_uploader_input', data: {
      upload_api_path: try("api_#{image_model_name.pluralize}_path"),
      image_model_name: image_model_name
    } do

      template.concat <<-EOF.strip_heredoc.html_safe
        <div class="image-thumbnail">
          <img src="#{image_model&.image&.try(thumbnail_size)&.url}" />
        </div>
      EOF

      template.concat IMAGE_INPUT_FIELD_HTML.html_safe

      template.concat @builder.input "belonging_#{attribute_name}_id"
    end
  end
end
