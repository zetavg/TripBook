# frozen_string_literal: true
class Book::Holding < ApplicationRecord
  include AASM
  include Trackable

  scope :active, -> { where(state: [:holding, :ready_for_release]) }

  belongs_to :user
  belongs_to :book
  belongs_to :previous_holding, optional: true, class_name: 'Book::Holding'

  aasm column: :state do
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

  before_validation :set_previous_holding, on: :create
  after_create :release_old_holdings
  after_destroy :rehold_previous_holding

  private

  def set_previous_holding
    self.previous_holding ||= book.holdings.active.last
  end

  def release_old_holdings
    book.holdings.active.where.not(id: id).find_each(&:release!)
  end

  def rehold_previous_holding
    previous_holding&.reload.update_attributes!(state: :holding)
  end
end
