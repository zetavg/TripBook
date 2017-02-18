# frozen_string_literal: true
FactoryGirl.define do
  factory :book_info do
    isbn { Faker::Code.isbn }
    name { Faker::Book.title }
    author { Faker::Book.author }
    publisher { Faker::Book.publisher }
    publish_date { Faker::Date.between(20.years.ago, 1.day.ago) }
  end
end
