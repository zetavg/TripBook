# frozen_string_literal: true
FactoryGirl.define do
  factory :book_borrowing_trip, class: 'Book::BorrowingTrip' do
    association :holding, factory: :book_holding
    max_single_durition_days 28
    max_durition_days 365
    max_borrowings_count 7

    trait :with_borrowings do
      transient do
        borrowings_count 3
      end

      after(:create) do |book_borrowing_trip, evaluator|
        create_list(:book_borrowing, evaluator.borrowings_count, borrowing_trip: book_borrowing_trip)
      end
    end
  end
end
