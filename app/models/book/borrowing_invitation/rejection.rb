# frozen_string_literal: true
class Book::BorrowingInvitation::Rejection < ActiveType::Object
  nests_one :invitation, scope: proc { Book::BorrowingInvitation.avaliable }
  nests_one :user, scope: proc { User.all }

  validates :invitation, :user, presence: true
  validate :validate_invitation_invites_user

  before_save :reject_user_invitation

  private

  def validate_invitation_invites_user
    return if invitation.invitees.include?(user)
    errors.add(:invitation, "illegal")
    errors.add(:user, "illegal")
  end

  def reject_user_invitation
    invitation.invitation_users.find_by(user: user).reject!
  end
end
