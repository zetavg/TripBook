# frozen_string_literal: true
FactoryGirl.define do
  factory :book_borrowing, class: 'Book::Borrowing' do
    association :borrowing_trip, factory: :book_borrowing_trip
    association :borrower, factory: :user
  end
end
