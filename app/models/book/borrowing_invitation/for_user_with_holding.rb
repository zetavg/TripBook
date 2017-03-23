# frozen_string_literal: true
class Book::BorrowingInvitation::ForUserWithHolding < ActiveType::Record[Book::BorrowingInvitation::InvitationUser]
  nests_one :holding, scope: proc { Book::Holding.ready_for_release }

  validates :holding, presence: true
  validate :validate_holding_state_is_ready_for_release

  before_validation :find_or_create_borrowing_invitation

  private

  def validate_holding_state_is_ready_for_release
    return if holding&.state == 'ready_for_release'
    errors.add(:holding, "state is not ready_for_release")
  end

  def find_or_create_borrowing_invitation
    self.borrowing_invitation ||= borrowing_invitation_scope.first || borrowing_invitation_scope.create!
  end

  def borrowing_invitation_scope
    Book::BorrowingInvitation.where(holding: holding)
  end
end
