# frozen_string_literal: true
class Book::Borrowing < ApplicationRecord
  include Trackable

  scope :active, -> { where(ended_at: nil) }

  belongs_to :borrowing_trip, counter_cache: true
  belongs_to :holding

  delegate :book, to: :borrowing_trip, prefix: false, allow_nil: true
  delegate :state, :previous_holding, :ready_for_release!, :cancel_release!, :story,
           to: :holding, prefix: false, allow_nil: true

  validates :borrower, presence: true

  after_create :set_borrowing_trip_to_in_progress_if_needed
  after_create :set_previous_borrowing_to_end

  def borrower
    holding&.user
  end

  def borrower=(user)
    (holding || build_holding(book: book)).user = user
  end

  def previous_borrowing
    self.class.find_by(holding_id: previous_holding.id)
  end

  def end!
    self.ended_at = Time.current
    save!
  end

  private

  def set_borrowing_trip_to_in_progress_if_needed
    return unless borrowing_trip.pending?
    borrowing_trip.in_progress!
  end

  def set_previous_borrowing_to_end
    borrowing_trip.borrowings.where.not(id: id).find_each(&:end!)
  end
end
