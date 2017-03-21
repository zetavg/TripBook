# frozen_string_literal: true
class Book::BorrowingTrip::Cancellation < ActiveType::Object
  nests_one :borrowing_trip, scope: proc { Book::BorrowingTrip.active }

  before_save :cancel_borrowing_trip

  validate :validate_borrowing_trip_not_ended

  private

  def validate_borrowing_trip_not_ended
    return unless borrowing_trip.ended?
    errors.add(:borrowing_trip, "has already ended")
  end

  def cancel_borrowing_trip
    if borrowing_trip.may_cancel?
      borrowing_trip.cancel!
    else
      borrowing_trip.prepare_to_end!
    end
  end
end
