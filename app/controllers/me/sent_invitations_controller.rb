# frozen_string_literal: true
class Me::SentInvitationsController < ApplicationController
  def index
    @show = (params[:show] || 'pending').underscore
    @borrowing_invitations = borrowing_invitations_scope(@show)
  end

  private

  def borrowing_invitations_scope(show = nil)
    case show
    when 'pending'
      current_user.sent_book_borrowing_invitations.avaliable
    when 'ended'
      current_user.sent_book_borrowing_invitations.ended
    else
      current_user.sent_book_borrowing_invitations
    end
  end
end
