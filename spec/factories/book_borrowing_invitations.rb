# frozen_string_literal: true
FactoryGirl.define do
  factory :book_borrowing_invitation, class: 'Book::BorrowingInvitation' do
    holding { create(:book_holding, state: :ready_for_release) }
  end
end
