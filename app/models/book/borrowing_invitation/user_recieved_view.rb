# frozen_string_literal: true
class Book::BorrowingInvitation::UserRecievedView < Book::BorrowingInvitation
  self.table_name = 'user_recieved_book_borrowing_invitations'

  scope :avaliable, -> { where(holding_state: :ready_for_release, state: :pending) }
  scope :rejected, -> { where(state: :rejected) }
  scope :accepted, -> { where(state: :accepted) }
  scope :not_accepted, -> { where.not(state: :accepted) }
  scope :ended, -> { where.not(holding_state: :ready_for_release) }

  belongs_to :user
  belongs_to :inviter, class_name: 'User'
  belongs_to :book
  belongs_to :info, class_name: 'BookInfo', primary_key: :isbn, foreign_key: :isbn
  belongs_to :story, class_name: 'Book::Story'

  def avaliable?
    self[:holding_state] == 'ready_for_release' && self[:state] == 'pending'
  end

  def accepted?
    self[:state] == 'accepted'
  end

  def rejected?
    self[:state] == 'rejected'
  end

  def ended?
    self[:state] == 'ended'
  end
end
