# frozen_string_literal: true
class Book::BorrowingInvitation::InvitationUser < ApplicationRecord
  belongs_to :borrowing_invitation
  belongs_to :user

  validates :user, uniqueness: { scope: :borrowing_invitation_id }
end
