# frozen_string_literal: true
class Me::InvitationsController < ApplicationController
  def index
    @invitations = invitations_scope.avaliable
  end

  private

  def invitations_scope
    current_user.recieved_book_borrowing_invitations
  end

  def find_invitation
    @invitation = invitations_scope.find(params[:invitation_id] || params[:id])
  end
end
