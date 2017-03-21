# frozen_string_literal: true
class Book::BorrowDemand::Cancellation < ActiveType::Object
  nests_one :borrow_demand, scope: proc { Book::BorrowDemand.active }

  before_save :cancel_borrow_demand

  validates :borrow_demand, presence: true
  validate :validate_borrow_demand_may_cancel

  private

  def validate_borrow_demand_may_cancel
    return if borrow_demand&.may_cancel?
    errors.add(:borrow_demand, "may not cancel")
  end

  def cancel_borrow_demand
    borrow_demand.cancel!
  end
end
