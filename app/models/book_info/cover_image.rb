# frozen_string_literal: true
class BookInfo::CoverImage < ApplicationRecord
  mount_uploader :image, BookCoverImageUploader

  belongs_to :book_info, primary_key: :isbn, foreign_key: :isbn
end
