# frozen_string_literal: true
class Book::BorrowingInvitation::InvitationUser < ApplicationRecord
  include StateMachine

  belongs_to :borrowing_invitation
  belongs_to :user

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
  validates :user, uniqueness: { scope: :borrowing_invitation_id }
end
