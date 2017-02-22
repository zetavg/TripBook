# frozen_string_literal: true
FactoryGirl.define do
  factory :book_story do
    user
    book_isbn { create(:book).isbn }
    content { Faker::Lorem.paragraphs }
  end
end
