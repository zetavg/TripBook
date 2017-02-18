# frozen_string_literal: true
class BookInfo < ApplicationRecord
  self.primary_key = :isbn
  mount_uploader :cover_image, BookCoverImageUploader

  validates :isbn, :name, presence: true
end
