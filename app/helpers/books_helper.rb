# frozen_string_literal: true
module BooksHelper
  def book_cover(book, responsive: false, style: nil)
    if book.cover_image.present?
      content_tag(
        :div,
        class: ['book-cover', responsive && 'book-cover-responsive'],
        style: style,
        'data-width': book.cover_image.dimensions[0],
        'data-height': book.cover_image.dimensions[1]
      ) do
        image_tag(book.cover_image&.image&.medium&.url)
      end
    else
      content_tag(
        :div,
        class: ['book-cover', responsive && 'book-cover-responsive'],
        style: style,
        'data-width': 300,
        'data-height': 420
      ) do
        content_tag(:div, class: 'title') do
          book.name
        end
      end
    end
  end
end
