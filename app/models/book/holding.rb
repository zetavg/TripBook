# frozen_string_literal: true
class Book::Holding < ApplicationRecord
  include StateMachine
  include Trackable
  include BorrowingRelations

  ACTIVE_STATES = %w(holding ready_for_release).freeze

  scope :active, -> { where(state: ACTIVE_STATES) }

  belongs_to :user
  belongs_to :book, touch: true
  belongs_to :previous_holding, optional: true, class_name: 'Book::Holding'

  has_one :story, class_name: 'Book::Story::HoldingView'

  state_machine column: :state do
    state :holding, initial: true
    state :ready_for_release
    state :released

    event :ready_for_release do
      transitions from: :holding, to: :ready_for_release

      before do |params|
        params ||= {}
        self.ready_for_released_at = params.fetch(:ready_for_released_at, Time.current)
      end
    end

    event :cancel_release do
      transitions from: :ready_for_release, to: :holding

      before do
        self.ready_for_released_at = nil
      end
    end

    event :release do
      transitions from: [:holding, :ready_for_release], to: :released

      before do |params|
        params ||= {}
        self.released_at = params.fetch(:released_at, Time.current)
      end
    end
  end

  validate :immutable_user_id, on: :update
  validate :immutable_book_id, on: :update

  before_validation :set_previous_holding, on: :create
  before_create :release_old_holdings
  after_destroy :rehold_previous_holding

  def active?
    ACTIVE_STATES.include?(state)
  end

  private

  def immutable_user_id
    return unless user_id_changed?
    errors.add(:user_id, 'is immutable')
  end

  def immutable_book_id
    return unless book_id_changed?
    errors.add(:book_id, 'is immutable')
  end

  def set_previous_holding
    self.previous_holding ||= book.holdings.active.last
  end

  def release_old_holdings
    book.holdings.active.where.not(id: id).find_each(&:release!)
  end

  def rehold_previous_holding
    previous_holding&.reload.update_attributes!(state: :holding, released_at: nil)
  end
end
