# frozen_string_literal: true
FactoryGirl.define do
  factory :book_borrow_demand, class: 'Book::BorrowDemand' do
    user
    book_isbn { create(:book).isbn }
  end
end
