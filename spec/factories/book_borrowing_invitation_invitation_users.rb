# frozen_string_literal: true
FactoryGirl.define do
  factory :book_borrowing_invitation_invitation_user, class: 'Book::BorrowingInvitation::InvitationUser' do
    association :borrowing_invitation, factory: :book_borrowing_invitation
    user
    message { Faker::Lorem.paragraph }
  end
end
