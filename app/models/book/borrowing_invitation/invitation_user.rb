# frozen_string_literal: true
class Book::BorrowingInvitation::InvitationUser < ApplicationRecord
  include StateMachine
  include Trackable

  scope :not_accepted, -> { where.not(state: :accepted) }

  belongs_to :borrowing_invitation
  belongs_to :user

  delegate :borrowing_trip, to: :borrowing_invitation, prefix: false, allow_nil: true

  state_machine column: :state do
    state :pending, initial: true
    state :accepted
    state :rejected

    event :accept do
      transitions from: :pending, to: :accepted
    end

    event :reject do
      transitions from: :pending, to: :rejected
    end
  end

  validates :user_id, :borrowing_invitation, presence: true
  validates :user_id, uniqueness: { scope: :borrowing_invitation_id, message: '已重複邀請' }
  validate :validate_borrowing_trip_is_pending_or_in_progress, on: :create

  private

  def validate_borrowing_trip_is_pending_or_in_progress
    return if borrowing_trip&.pending? || borrowing_trip&.in_progress?
    errors.add(:borrowing_trip, :not_pending_or_in_progress)
  end
end
