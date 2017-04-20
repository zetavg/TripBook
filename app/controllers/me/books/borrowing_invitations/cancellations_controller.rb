# frozen_string_literal: true
class Me::Books::BorrowingInvitations::CancellationsController < Me::Books::BorrowingInvitationsController
  layout 'me/books'

  def create
    find_borrowing_invitation_for_user
    @cancellation = Book::BorrowingInvitation::InvitationUser::Cancellation.new(
      invitation_user: @borrowing_invitation_for_user
    )

    if @cancellation.save
      redirect_to :back, flash: { success: '已撤銷邀請' }
    else
      redirect_to :back, flash: { error: '操作失敗' }
    end
  end
end
