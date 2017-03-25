# frozen_string_literal: true
class Book::BorrowingInvitation < ApplicationRecord
  scope :avaliable, -> { joins(:holding).where('holdings.state': :ready_for_release) }

  belongs_to :holding
  belongs_to :borrowing, optional: true
  has_many :invitation_users
  has_many :invitees, through: :invitation_users, source: :user

  delegate :state, :story, to: :holding, prefix: false
  accepts_nested_attributes_for :invitation_users, allow_destroy: true

  validates :holding, uniqueness: true
  validate :validate_state_is_ready_for_release, on: :create

  def borrowing_trip
    holding.borrowing&.borrowing_trip || holding.book.current_borrowing_trip
  end

  private

  def validate_state_is_ready_for_release
    return if state == 'ready_for_release'
    errors.add(:holding, "state is not ready_for_release")
  end
end
