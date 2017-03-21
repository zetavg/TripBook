# frozen_string_literal: true
class Book::BorrowingTrip < ApplicationRecord
  include StateMachine
  include Trackable

  ACTIVE_STATES = %w(pending in_progress prepare_to_end).freeze
  END_STATES = %w(ended).freeze

  scope :active, -> { where(state: ACTIVE_STATES) }
  scope :complete, -> { where(state: :ended).where('borrowings_count > 0') }
  scope :for_book, ->(book) { where(book: book) }

  belongs_to :book
  has_many :borrowings, foreign_key: :book_borrowing_trip_id
  has_one :current_borrowing, -> { active }, foreign_key: :book_borrowing_trip_id, class_name: 'Borrowing'

  validates :book, uniqueness: { scope: :state }, unless: :end?

  state_machine column: :state do
    state :pending, initial: true
    state :in_progress
    state :prepare_to_end
    state :ended

    event :in_progress do
      transitions from: :pending, to: :in_progress
    end

    event :end do
      transitions from: [:pending, :in_progress, :prepare_to_end], to: :ended do
        guard do
          book.holder == book.owner
        end
      end

      before do |params|
        params ||= {}
        self.ended_at = params.fetch(:released_at, Time.current)
      end
    end

    event :prepare_to_end do
      transitions from: :in_progress, to: :prepare_to_end
    end

    event :cancel do
      transitions from: :pending, to: :ended
    end
  end

  validate :validate_book_hold_by_owner, on: :create

  after_initialize :prepare_to_end_if_needed
  after_initialize :end_if_needed
  after_create :set_current_holding_to_ready_for_release
  after_save :set_current_holding_to_holding_if_needed
  after_save :end_borrowings_if_ended

  def active?
    ACTIVE_STATES.include?(state)
  end

  def end?
    END_STATES.include?(state)
  end

  def max_single_durition
    max_single_durition_days&.days
  end

  def max_single_durition=(max_single_durition_days)
    if max_single_durition_days.is_a? ActiveSupport::Duration
      max_single_durition_days = max_single_durition_days.to_i / 1.day.to_i
    end

    self.max_single_durition_days = max_single_durition_days
  end

  def max_durition
    max_durition_days&.days
  end

  def max_durition=(max_durition_days)
    if max_durition_days.is_a? ActiveSupport::Duration
      max_durition_days = max_durition_days.to_i / 1.day.to_i
    end

    self.max_durition_days = max_durition_days
  end

  def durition
    end_date = ended_at || Time.current

    (end_date - (created_at || Time.current)).seconds
  end

  def should_be_prepare_to_end?
    borrowings_count >= (max_borrowings_count || Float::INFINITY) ||
      (durition + 1.week) >= (max_durition || Float::INFINITY)
  end

  def next_step
    case state
    when 'pending'
      :lend
    when 'in_progress'
      :pass_on
    when 'prepare_to_end'
      :return
    end
  end

  private

  def validate_book_hold_by_owner
    return if book.holder == book.owner
    errors.add(:book, "not holding by owner")
  end

  def prepare_to_end_if_needed
    return if ended?
    return unless should_be_prepare_to_end?
    cancel! if may_cancel?
    prepare_to_end! if may_prepare_to_end?
  end

  def end_if_needed
    return if end?
    return unless book&.current_holding&.holding?
    end! if book.holder == book.owner
  end

  def set_current_holding_to_ready_for_release
    book.current_holding.ready_for_release! if book.current_holding.may_ready_for_release?
  end

  def set_current_holding_to_holding_if_needed
    return unless end?
    if state_was == 'pending' &&
       book.holder == book.owner &&
       book.current_holding.ready_for_release?
      book.current_holding.cancel_release!
    end
  end

  def end_borrowings_if_ended
    return unless end?
    borrowings.where(ended_at: nil).find_each(&:end!)
  end
end
