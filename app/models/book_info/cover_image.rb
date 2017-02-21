# frozen_string_literal: true
class BookInfo::CoverImage < ApplicationRecord
  mount_uploader :image, BookCoverImageUploader

  belongs_to :book_info, primary_key: :isbn, foreign_key: :isbn, optional: true

  validate :immutable_isbn, on: :update

  private

  def immutable_isbn
    return if isbn_was.blank?
    return unless isbn_changed?
    errors.add(:isbn, 'is immutable')
  end
end
