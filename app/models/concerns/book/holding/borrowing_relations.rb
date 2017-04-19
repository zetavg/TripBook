# frozen_string_literal: true
class Book::Holding
  module BorrowingRelations
    extend ActiveSupport::Concern

    included do
      has_many :borrowing_trips, class_name: 'Book::BorrowingTrip'
      has_one :borrowing_trip, -> { reorder(created_at: :desc) }, class_name: 'Book::BorrowingTrip'
      has_one :borrowing
      has_one :borrowing_invitation
      # TODO: add more
    end
  end
end
