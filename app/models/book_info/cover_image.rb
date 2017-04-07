# frozen_string_literal: true
class BookInfo::CoverImage < ApplicationRecord
  mount_uploader :image, BookCoverImageUploader

  belongs_to :book_info, primary_key: :isbn, foreign_key: :isbn, optional: true

  validate :immutable_isbn, on: :update

  def dimensions(max_width: 296.0, max_height: 420.0)
    return [max_width, max_height].map(&:to_i) unless image.present?
    width_scale = max_width.to_f / width
    height_scale = max_height.to_f / height
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
