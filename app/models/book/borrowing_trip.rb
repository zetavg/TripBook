# frozen_string_literal: true
class Book::BorrowingTrip < ApplicationRecord
  include StateMachine
  include Trackable

  ACTIVE_STATES = %w(pending in_progress prepare_to_end).freeze
  END_STATES = %w(ended).freeze

  scope :active, -> { where(state: ACTIVE_STATES) }
  scope :complete, -> { where(state: :ended).where('borrowings_count > 0') }
  scope :for_book, ->(book) { joins(:holding).where('book_holdings.book_id = ?', book.try(:id) || book) }

  belongs_to :holding, class_name: 'Holding'
  has_one :book, through: :holding
  has_many :borrowings, -> { order(created_at: :asc) }
  has_one :current_borrowing, -> { active }, class_name: 'Borrowing'

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
          book.holder == holding.user
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

      before do |params|
        params ||= {}
        self.ended_at = params.fetch(:released_at, Time.current)
      end
    end
  end

  validates :holding, presence: true
  validate :validate_holding_active, on: :create
  validate :validate_unique_active_for_book, unless: :end?

  after_initialize :nilify_blanks
  after_initialize :prepare_to_end_if_needed
  after_initialize :end_if_needed
  before_validation :nilify_blanks
  after_create :set_current_holding_to_ready_for_release
  after_save :set_current_holding_to_holding_if_needed
  after_save :end_borrowings_if_ended

  def active?
    ACTIVE_STATES.include?(state)
  end

  def end?
    END_STATES.include?(state)
  end

  def book=(book)
    self.holding = book.current_holding
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

  def validate_holding_active
    return if holding&.active?
    errors.add(:holding, :not_active)
  end

  def validate_unique_active_for_book
    return unless book&.borrowing_trips&.active&.where&.not(id: id)&.any?
    errors.add(:book, :already_has_active_borrowing_trip)
  end

  def nilify_blanks
    self.max_single_durition_days = nil if max_single_durition_days&.zero?
    self.max_durition_days = nil if max_durition_days&.zero?
    self.max_borrowings_count = nil if max_borrowings_count&.zero?
  end

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
