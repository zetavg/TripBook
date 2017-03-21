# frozen_string_literal: true
class BookInfo
  module BorrowingRelations
    extend ActiveSupport::Concern

    included do
      has_many :borrow_demands, class_name: 'Book::BorrowDemand', primary_key: :isbn, foreign_key: :book_isbn
      # TODO: add more
    end
  end
end
