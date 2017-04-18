# frozen_string_literal: true
class BookInfoInput < SimpleForm::Inputs::Base
  include Rails.application.routes.url_helpers

  def input(_wrapper_options = nil)
    # rubocop:disable OutputSafety
    allow_create = options[:allow_create] || false
    object.build_info if object.info.blank?
    value = object.try(:info).persisted? ? object[attribute_name] : nil
    book_info = object.try(:info)

    template.content_tag :div, class: 'book_info_input', data: {
      api_book_infos_path: api_book_infos_path,
      allow_create: allow_create,
      value: value,
      info_name: book_info&.name,
      info_cover_image_url: book_info&.cover_image && book_info&.cover_image&.image&.thumbnail&.url,
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
          template.concat '<p>這本書目前尚未在我們的系統中建檔，請填寫以下資訊協助我們認識它吧！</p>'.html_safe
          template.concat(@builder.simple_fields_for(:info) do |f|
            template.concat f.input :isbn, label: I18n.t(:isbn, scope: 'models.attributes.book_info'),
                                           required: false,
                                           hint: '必填，請輸入書本條碼上 10 或 13 碼的 ISBN 號碼'
            template.concat f.input :name, label: I18n.t(:name, scope: 'models.attributes.book_info'),
                                           required: false,
                                           hint: '必填，請盡量輸入完整正確的書名喔'
            cover_image_hint = <<-EOF
              <a href="https://www.google.com/search?q=#{object.info.name&.tr(' ', '+')}&tbm=isch" target="_blank">
                尋找並上傳封面圖片，讓大家對這本書更有印象
              </a>
            EOF
            template.concat f.input :cover_image,
                                    label: I18n.t(:cover_image, scope: 'models.attributes.book_info'),
                                    as: :basic_image_uploader,
                                    hint: cover_image_hint.html_safe
            template.concat f.input :author, label: I18n.t(:author, scope: 'models.attributes.book_info')
            template.concat f.input :publisher, label: I18n.t(:publisher, scope: 'models.attributes.book_info')
          end)
        end

        template.concat new_info_block
      end
    end
  end
end
