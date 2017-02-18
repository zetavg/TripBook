# frozen_string_literal: true
FactoryGirl.define do
  factory :book do
    user
    association :info, factory: :book_info
  end
end
