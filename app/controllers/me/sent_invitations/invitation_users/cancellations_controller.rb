# frozen_string_literal: true
class Me::SentInvitations::InvitationUsers::CancellationsController < Me::SentInvitations::InvitationUsersController
  def create
    find_invitation_user

    @cancellation = Book::BorrowingInvitation::InvitationUser::Cancellation.new(
      invitation_user: @invitation_user
    )

    if @cancellation.save
      redirect_back fallback_location: me_sent_invitations_path, flash: { success: '已撤銷邀請' }
    else
      redirect_back fallback_location: me_sent_invitations_path, flash: { error: '操作失敗' }
    end
  end
end
