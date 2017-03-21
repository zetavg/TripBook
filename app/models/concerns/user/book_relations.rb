# frozen_string_literal: true
class User
  module BookRelations
    extend ActiveSupport::Concern

    included do
      has_many :owned_books, class_name: 'Book', foreign_key: :owner_id
      has_many :book_holdings, class_name: 'Book::Holding'
      has_many :past_holded_books, -> { distinct }, through: :book_holdings, source: :book
      has_many :active_book_holdings, -> { active }, class_name: 'Book::Holding'
      has_many :holding_books, through: :active_book_holdings, source: :book
      has_many :book_stories, class_name: 'Book::Story'
      has_many :book_summaries, class_name: 'Book::Summary'
    end
  end
end
