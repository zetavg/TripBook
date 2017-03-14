# frozen_string_literal: true
FactoryGirl.define do
  factory :book_summary, class: Book::Summary do
    user
    book_isbn { create(:book).isbn }
    content { Faker::Lorem.paragraphs }
  end
end
