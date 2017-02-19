# frozen_string_literal: true
class Book < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :holdings, class_name: 'BookHolding'
  has_many :past_holders, through: :holdings, source: :user
  has_one :current_holding, -> { active }, class_name: 'BookHolding'
  has_one :holder, through: :current_holding, source: :user
  belongs_to :info, class_name: 'BookInfo', primary_key: :isbn, foreign_key: :isbn

  accepts_nested_attributes_for :info

  delegate :isbn_10, :isbn_13,
           :name, :cover_image, :language, :author, :publisher, :publish_date,
           to: :info, prefix: false

  after_create :create_book_holding_on_create

  private

  def create_book_holding_on_create
    holdings.create!(user: owner)
  end
end
