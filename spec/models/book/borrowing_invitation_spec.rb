# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Book::BorrowingInvitation, type: :model do
  it "validates if the book has valid borrowing trip on create" do
    borrowing_trip = create(:book_borrowing_trip, :with_borrowings)
    invitation = build(:book_borrowing_invitation, holding: borrowing_trip.book.current_holding)
    expect(invitation).to be_valid
    borrowing_trip.prepare_to_end!
    expect(invitation).not_to be_valid
    invitation.save!(validate: false)
    expect(invitation).to be_valid
  end
end
