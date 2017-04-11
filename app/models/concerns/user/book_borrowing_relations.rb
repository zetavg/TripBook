# frozen_string_literal: true
class User
  module BookBorrowingRelations
    extend ActiveSupport::Concern

    included do
      has_many :book_borrow_demands, class_name: 'Book::BorrowDemand'
      has_many :sent_book_borrowing_invitations, class_name: 'Book::BorrowingInvitation',
                                                 through: :book_holdings,
                                                 source: :borrowing_invitation
      has_many :recieved_book_borrowing_invitations, class_name: 'Book::BorrowingInvitation::UserRecievedView'
      # TODO: add more
    end
  end
end
