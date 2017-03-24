# frozen_string_literal: true
class Me::InvitationsController < ApplicationController
  def index
    @invitations = invitations_scope.avaliable
  end

  private

  def invitations_scope
    current_user.recieved_book_borrowing_invitations
  end
end
