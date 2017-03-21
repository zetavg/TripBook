# frozen_string_literal: true
class Book::BorrowingTrip::Returnation < ActiveType::Object
  nests_one :borrowing_trip, scope: proc { Book::BorrowingTrip.active }

  before_save :create_book_holding_for_owner

  validate :validate_borrowing_trip_not_ended

  private

  def validate_borrowing_trip_not_ended
    return unless borrowing_trip.ended?
    errors.add(:borrowing_trip, "has already ended")
  end

  def create_book_holding_for_owner
    borrowing_trip.book.holdings.create!(user: borrowing_trip.book.owner)
    borrowing_trip.reload
  end
end
