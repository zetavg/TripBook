# frozen_string_literal: true
FactoryGirl.define do
  factory :book do
    association :owner, factory: :user
    association :info, factory: :book_info
  end
end
