# frozen_string_literal: true
class Book::BorrowDemand::DemandUser < ApplicationRecord
  belongs_to :borrow_demand
  belongs_to :user
end
