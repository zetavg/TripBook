# frozen_string_literal: true
class Book::BorrowingInvitation::Acception < ActiveType::Object
  nests_one :invitation, scope: proc { Book::BorrowingInvitation.avaliable }
  nests_one :user, scope: proc { User.all }

  validates :invitation, :user, presence: true
  validate :validate_invitation_invites_user

  before_save :accept_user_invitation
  before_save :create_borrowing

  private

  def validate_invitation_invites_user
    return if invitation.invitees.include?(user)
    errors.add(:invitation, "illegal")
    errors.add(:user, "illegal")
  end

  def accept_user_invitation
    invitation.invitation_users.find_by(user: user).accept!
  end

  def create_borrowing
    @borrowing = invitation.borrowing_trip.borrowings.new
    @borrowing.borrower = user
    @borrowing.save!
  end
end
