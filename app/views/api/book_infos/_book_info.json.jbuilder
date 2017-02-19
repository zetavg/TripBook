# frozen_string_literal: true
json.isbn book_info.isbn
json.isbn_10 book_info.isbn_10
json.isbn_13 book_info.isbn_13
json.name book_info.name
if book_info.cover_image.present?
  json.cover_image book_info.cover_image, partial: 'api/book_info_cover_images/book_info_cover_image',
                                          as: :book_info_cover_image
end
json.language book_info.language
json.author book_info.author
json.publisher book_info.publisher
json.publish_date book_info.publish_date
