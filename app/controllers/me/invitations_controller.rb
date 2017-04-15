# frozen_string_literal: true
class Me::InvitationsController < ApplicationController
  def index
    @show = (params[:show] || 'pending').underscore
    @invitations = invitations_scope(@show).reorder(updated_at: :desc)
  end

  private

  def invitations_scope(show = nil)
    case show
    when 'pending'
      current_user.recieved_book_borrowing_invitations.avaliable
    when 'accepted'
      current_user.recieved_book_borrowing_invitations.accepted
    when 'rejected'
      current_user.recieved_book_borrowing_invitations.rejected
    when 'ended'
      current_user.recieved_book_borrowing_invitations.not_accepted.ended
    else
      current_user.recieved_book_borrowing_invitations
    end
  end

  def find_invitation
    @invitation = invitations_scope.find(params[:invitation_id] || params[:id])
  end
end
