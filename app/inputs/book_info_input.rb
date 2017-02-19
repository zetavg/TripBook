# frozen_string_literal: true
class BookInfoInput < SimpleForm::Inputs::Base
  include Rails.application.routes.url_helpers

  def input(_wrapper_options = nil)
    template.content_tag :div, class: 'book_info_input', data: { api_book_infos_path: api_book_infos_path } do
      template.concat @builder.select(attribute_name, {}, {}, data: { isbn_select: true }, style: 'width: 100%;')
    end
  end
end
