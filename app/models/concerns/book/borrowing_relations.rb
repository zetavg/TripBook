# frozen_string_literal: true
class Book
  module BorrowingRelations
    extend ActiveSupport::Concern

    included do
      has_many :borrow_demands, class_name: 'Book::BorrowDemand', primary_key: :book_isbn, foreign_key: :book_isbn
      has_many :borrowing_trips, class_name: 'Book::BorrowingTrip'
      has_one :current_borrowing_trip, -> { active }, class_name: 'Book::BorrowingTrip'
      # TODO: add more
    end
  end
end
