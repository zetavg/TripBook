# frozen_string_literal: true
class BookInfo < ApplicationRecord
  self.primary_key = :isbn
  mount_uploader :cover_image, BookCoverImageUploader

  has_many :books, primary_key: :isbn, foreign_key: :isbn

  validates :isbn, :name, presence: true
end
