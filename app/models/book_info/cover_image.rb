# frozen_string_literal: true
class BookInfo::CoverImage < ApplicationRecord
  mount_uploader :image, BookCoverImageUploader

  belongs_to :book_info, primary_key: :isbn, foreign_key: :isbn, optional: true

  validate :immutable_isbn, on: :update

  def dimensions
    width_scale = 296.0 / width
    height_scale = 420.0 / height
    min_scale = [width_scale, height_scale].min
    [width, height].map { |i| i * min_scale }.map(&:to_i)
  end

  private

  def immutable_isbn
    return if isbn_was.blank?
    return unless isbn_changed?
    errors.add(:isbn, 'is immutable')
  end
end
