# frozen_string_literal: true
FactoryGirl.define do
  factory :book_holding, class: Book::Holding do
    user
    book
  end
end
