# frozen_string_literal: true
class Me::SentInvitations::InvitationUsersController < ApplicationController
  def new
    find_borrowing_invitation
    @invitation_user = @borrowing_invitation.invitation_users.build
  end

  def create
    find_borrowing_invitation
    @invitation_user = @borrowing_invitation.invitation_users.build(invitation_user_params)

    if @invitation_user.save
      redirect_back fallback_location: me_sent_invitations_path, flash: { success: '邀請已送出' }
    else
      render :new
    end
  end

  private

  def find_invitation_user
    find_borrowing_invitation if @borrowing_invitation.blank?
    @invitation_user = @borrowing_invitation.invitation_users.find(params[:invitation_user_id] || params[:id])
  end

  def find_borrowing_invitation
    @borrowing_invitation = borrowing_invitations_scope.find(params[:sent_invitation_id])
  end

  def borrowing_invitations_scope
    current_user.sent_book_borrowing_invitations
  end

  def invitation_user_params
    params.require(:book_borrowing_invitation_invitation_user).permit(:user_id, :message)
  end
end
