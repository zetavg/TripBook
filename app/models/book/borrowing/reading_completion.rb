# frozen_string_literal: true
class Book::Borrowing::ReadingCompletion < ActiveType::Object
  nests_one :borrowing, scope: proc { Book::Borrowing.active }

  before_save :set_ready_for_release

  validates :borrowing, presence: true
  validate :validate_borrowing_state_is_holding

  private

  def validate_borrowing_state_is_holding
    return if borrowing&.state == 'holding'
    errors.add(:borrowing, "is not holding")
  end

  def set_ready_for_release
    borrowing.ready_for_release!
  end
end
