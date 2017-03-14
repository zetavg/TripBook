# frozen_string_literal: true
class Book < ApplicationRecord
  attr_accessor :for_user

  belongs_to :owner, class_name: 'User'
  has_many :holdings
  has_many :past_holders, through: :holdings, source: :user
  has_one :current_holding, -> { active }, class_name: 'Book::Holding'
  has_one :holder, through: :current_holding, source: :user
  belongs_to :info, class_name: 'BookInfo', primary_key: :isbn, foreign_key: :isbn
  has_many :stories, through: :past_holders, source: :book_stories, class_name: 'Book::Story'
  has_many :summaries, through: :past_holders, source: :book_summaries, class_name: 'Book::Summary'
  has_one :story,
          ->(o) {
            if o.for_user
              where(user_id: o.for_user.try(:id) || o.for_user)
            else
              where(user_id: o.holder.try(:id))
            end
          },
          primary_key: :isbn, foreign_key: :book_isbn
  has_one :summary,
          ->(o) {
            if o.for_user
              where(user_id: o.for_user.try(:id) || o.for_user)
            else
              where(user_id: o.holder.try(:id))
            end
          },
          primary_key: :isbn, foreign_key: :book_isbn

  accepts_nested_attributes_for :info
  accepts_nested_attributes_for :story
  accepts_nested_attributes_for :summary

  delegate :isbn_10, :isbn_13,
           :name, :cover_image, :language, :author, :publisher, :publish_date,
           to: :info, prefix: false

  after_create :create_book_holding_on_create

  def for(user)
    self.for_user = user
    self
  end

  private

  def create_book_holding_on_create
    holdings.create!(user: owner)
  end
end
