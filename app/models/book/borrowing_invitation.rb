# frozen_string_literal: true
class Book::BorrowingInvitation < ApplicationRecord
  scope :avaliable, -> { joins(:holding).where('book_holdings.state': :ready_for_release) }
  scope :ended, -> { joins(:holding).where('book_holdings.state': :released) }

  belongs_to :holding
  has_one :inviter, through: :holding, source: :user
  has_one :book, through: :holding, source: :book
  has_one :holding_borrowing, through: :holding, source: :borrowing
  has_one :holding_borrowing_trip, through: :holding, source: :borrowing_trip
  belongs_to :borrowing, optional: true
  has_one :borrowing_trip, through: :holding_borrowing
  has_many :invitation_users
  has_many :invitees, through: :invitation_users, source: :user
  has_one :accepted_invitation_user, -> { accepted }, class_name: 'InvitationUser'
  has_one :accepted_invitee, through: :accepted_invitation_user, source: :user
  has_many :not_accepted_invitation_users, -> { not_accepted }, class_name: 'InvitationUser'
  has_many :not_accepted_invitees, through: :not_accepted_invitation_users, source: :user

  delegate :state, :story, to: :holding, prefix: false
  accepts_nested_attributes_for :invitation_users, allow_destroy: true

  validates :holding, uniqueness: true
  validate :validate_state_is_ready_for_release, on: :create

  def borrowing_trip
    super || holding_borrowing_trip
  end

  def avaliable?
    state == 'ready_for_release'
  end

  def accepted?
    state == 'released'
  end

  def ended?
    state == 'released'
  end

  private

  def validate_state_is_ready_for_release
    return if state == 'ready_for_release'
    errors.add(:holding, "state is not ready_for_release")
  end
end
