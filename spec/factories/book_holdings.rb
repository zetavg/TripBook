# frozen_string_literal: true
FactoryGirl.define do
  factory :book_holding do
    user
    book
  end
end
