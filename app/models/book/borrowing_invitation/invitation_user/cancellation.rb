# frozen_string_literal: true
class Book::BorrowingInvitation::InvitationUser::Cancellation < ActiveType::Object
  nests_one :invitation_user, scope: proc { Book::BorrowingInvitation::InvitationUser.all }

  before_save :destroy_invitation_user

  validates :invitation_user, presence: true

  private

  def destroy_invitation_user
    invitation_user.destroy!
  end
end
