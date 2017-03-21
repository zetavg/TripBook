# frozen_string_literal: true
FactoryGirl.define do
  factory :book_story, class: Book::Story do
    user
    book_isbn { create(:book).isbn }
    content { Faker::Lorem.paragraphs.join(' ') }
  end
end
