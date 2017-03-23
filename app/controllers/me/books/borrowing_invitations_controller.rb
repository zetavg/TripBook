# frozen_string_literal: true
class Me::Books::BorrowingInvitationsController < ApplicationController
  before_action :ensure_book_in_hand_and_ready_for_release

  def index
    find_borrowing_invitation
    redirect_to new_me_book_borrowing_invitation_path(book_id: @book.id) unless @borrowing_invitation&.invitees&.any?
  end

  def new
    build_borrowing_invitation_for_user
  end

  def create
    build_borrowing_invitation_for_user
    @borrowing_invitation_for_user.assign_attributes(book_borrowing_invitation_invitation_user_params)

    if @borrowing_invitation_for_user.save
      redirect_to me_book_borrowing_invitations_path(book_id: @book.id)
    else
      render :new
    end
  end

  private

  def ensure_book_in_hand_and_ready_for_release
    book = (@book || find_book)
    unless book.holder == current_user &&
           book.current_holding.ready_for_release?
      redirect_to root_path, flash: { error: '無法執行操作' }
    end
  end

  def books_scope
    current_user.holding_books
  end

  def find_book
    @book = books_scope.find(params[:book_id])
  end

  def find_borrowing_invitation
    @borrowing_invitation = (@book || find_book)&.current_holding&.borrowing_invitation
  end

  def find_borrowing_invitation_for_user
    id = params[:id] || params[:borrowing_invitation_id]
    @borrowing_invitation_for_user = (@borrowing_invitation || find_borrowing_invitation)&.invitation_users.find(id)
  end

  def build_borrowing_invitation_for_user
    @borrowing_invitation_for_user = Book::BorrowingInvitation::ForUserWithHolding.new(
      holding: (@book || find_book).current_holding
    )
  end

  def book_borrowing_invitation_invitation_user_params
    params.require(:book_borrowing_invitation_invitation_user).permit(
      :user_id, :message
    )
  end
end
