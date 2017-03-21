# frozen_string_literal: true
class Book::BorrowDemand < ApplicationRecord
  include StateMachine
  include Trackable

  ACTIVE_STATES = %w(pending).freeze
  END_STATES = %w(fulfilled canceled).freeze

  scope :active, -> { where(state: ACTIVE_STATES) }

  belongs_to :user
  belongs_to :borrowings, optional: true, class_name: 'Book::Borrowing'
  belongs_to :book_info, primary_key: :isbn, foreign_key: :book_isbn
  has_many :books, primary_key: :book_isbn, foreign_key: :book_isbn

  state_machine column: :state do
    state :pending, initial: true
    state :fulfilled
    state :canceled

    event :fulfill do
      transitions from: :pending, to: :fulfilled
    end

    event :cancel do
      transitions from: :pending, to: :canceled
    end
  end

  validates :book_isbn, uniqueness: { scope: :state }, unless: :end?

  def active?
    ACTIVE_STATES.include?(state)
  end

  def end?
    END_STATES.include?(state)
  end
end
