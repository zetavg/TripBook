# frozen_string_literal: true
class BookInfoInput < SimpleForm::Inputs::Base
  include Rails.application.routes.url_helpers

  def input(_wrapper_options = nil)
    allow_create = options[:allow_create] || false
    value = object.try(:info).persisted? ? object[attribute_name] : nil
    book_info = object.try(:info)

    template.content_tag :div, class: 'book_info_input', data: {
      api_book_infos_path: api_book_infos_path,
      allow_create: allow_create,
      value: value,
      info_name: book_info&.name,
      info_cover_image_url: book_info&.cover_image&.image&.thumbnail&.url,
      info_language: book_info&.language,
      info_author: book_info&.author,
      info_publisher: book_info&.publisher,
      info_publish_date: book_info&.publish_date
    } do
      template.concat @builder.select(attribute_name, {}, {}, data: { isbn_select: true }, style: 'width: 100%;')

      if allow_create
        new_info_block = template.content_tag :div, data: {
          new_info_block: true
        } do
          template.concat(@builder.simple_fields_for(:info) do |f|
            template.concat f.input :isbn
            template.concat f.input :name
            template.concat f.input :author
            template.concat f.input :publisher
          end)
        end

        template.concat new_info_block
      end
    end
  end
end
