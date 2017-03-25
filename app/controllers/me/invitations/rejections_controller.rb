# frozen_string_literal: true
class Me::Invitations::RejectionsController < Me::InvitationsController
  def create
    find_invitation
    @rejection = Book::BorrowingInvitation::Rejection.new(invitation: @invitation, user: current_user)

    @rejection.save!
    redirect_to me_invitations_path, flash: { success: '已謝絕邀請' }
  end
end
