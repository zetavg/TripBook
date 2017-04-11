# frozen_string_literal: true
class Me::Invitations::AcceptionsController < Me::InvitationsController
  def create
    find_invitation
    @acception = Book::BorrowingInvitation::Acception.new(invitation: @invitation, user: current_user)

    @acception.save!
    redirect_to me_invitations_path(show: :accepted), flash: { success: '已接受邀請，您現在可以看到對方的聯絡資訊' }
  end
end
