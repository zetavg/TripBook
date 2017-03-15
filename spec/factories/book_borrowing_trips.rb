# frozen_string_literal: true
FactoryGirl.define do
  factory :book_borrowing_trip, class: 'Book::BorrowingTrip' do
    book
    max_single_durition_days 28
    max_durition_days 365
    max_borrowings_count 7
  end
end
