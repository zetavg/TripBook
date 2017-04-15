# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Book::BorrowingInvitation::InvitationUser, type: :model do
  it "validates if the book has valid borrowing trip on create" do
    borrowing_trip = create(:book_borrowing_trip, :with_borrowings)
    invitation = create(:book_borrowing_invitation, holding: borrowing_trip.book.current_holding)
    invitation_user = build(:book_borrowing_invitation_invitation_user, borrowing_invitation: invitation)
    expect(invitation_user).to be_valid
    borrowing_trip.prepare_to_end!
    invitation_user.borrowing_trip.reload
    expect(invitation_user).not_to be_valid
    invitation_user.save!(validate: false)
    expect(invitation_user).to be_valid
  end
end
