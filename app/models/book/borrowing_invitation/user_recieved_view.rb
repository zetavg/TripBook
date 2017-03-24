# frozen_string_literal: true
class Book::BorrowingInvitation::UserRecievedView < Book::BorrowingInvitation
  self.table_name = 'user_recieved_book_borrowing_invitations'

  scope :avaliable, -> { where(holding_state: :ready_for_release, state: :pending) }
  scope :rejected, -> { where(state: :rejected) }
  scope :ended, -> { where.not(holding_state: :ready_for_release) }

  belongs_to :user
  belongs_to :inviter, class_name: 'User'
  belongs_to :book
  belongs_to :info, class_name: 'BookInfo', primary_key: :isbn, foreign_key: :isbn
  belongs_to :story, class_name: 'Book::Story'
end
