# frozen_string_literal: true
FactoryGirl.define do
  factory :book_borrow_demand_demand_user, class: 'Book::BorrowDemand::DemandUser' do
    association :borrow_demand, factory: :book_borrow_demand
    user
    message { Faker::Lorem.paragraph }
  end
end
