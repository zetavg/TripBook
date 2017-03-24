# frozen_string_literal: true
class Book::BorrowingInvitation::InvitationUser < ApplicationRecord
  include StateMachine

  belongs_to :borrowing_invitation
  belongs_to :user

  state_machine column: :state do
    state :pending, initial: true
  end

  validates :user, uniqueness: { scope: :borrowing_invitation_id }
end
