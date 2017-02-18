# frozen_string_literal: true
class Book < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  belongs_to :info, class_name: 'BookInfo', primary_key: :isbn, foreign_key: :isbn

  delegate :isbn_10, :isbn_13,
           :name, :cover_image, :language, :author, :publisher, :publish_date,
           to: :info, prefix: false
end
