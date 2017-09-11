# frozen_string_literal: true
class Book
  module BorrowingRelations
    extend ActiveSupport::Concern

    included do
      has_many :borrow_demands, class_name: 'Book::BorrowDemand', primary_key: :book_isbn, foreign_key: :book_isbn
      has_many :borrowing_trips, class_name: 'Book::BorrowingTrip', through: :holdings, source: :borrowing_trip
      has_one :current_borrowing_trip_holding,
              -> { joins(:borrowing_trip).where('book_borrowing_trips.state': Book::BorrowingTrip::ACTIVE_STATES) },
              class_name: 'Book::Holding'
      has_one :current_borrowing_trip, class_name: 'Book::BorrowingTrip',
                                       through: :current_borrowing_trip_holding,
                                       source: :borrowing_trip
      # TODO: add more
    end

    def current_borrowing_user
      current_borrowing_trip&.current_borrowing&.borrower
    end
  end
end
