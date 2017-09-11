# frozen_string_literal: true
class Book::BorrowOut < ActiveType::Object
  nests_one :book, scope: proc { Book.all }
  nests_many :invitation_users, scope: proc { Book::BorrowingInvitation::InvitationUser.all }
  attribute :trip_max_single_durition_days, :integer
  attribute :trip_max_durition_days, :integer
  attribute :trip_max_borrowings_count, :integer

  validates :book, presence: true
  validate :validate_book_is_holding_by_owner

  after_initialize :prepare_borrowing_trip
  after_initialize :init_attributes_from_borrowing_trip

  before_validation :prepare_borrowing_trip
  before_validation :assign_attributes_to_borrowing_trip
  before_validation :prepare_borrowing_invitation
  before_validation :assign_borrowing_invitation_for_borrowing_invitation_users

  before_save :prepare_borrowing_trip
  before_save :assign_attributes_to_borrowing_trip
  before_save :save_borrowing_trip
  before_save :prepare_borrowing_invitation
  before_save :save_borrowing_invitation
  before_save :assign_borrowing_invitation_for_borrowing_invitation_users

  private

  def prepare_borrowing_trip
    @borrowing_trip = Book::BorrowingTrip.for_book(book).pending.first_or_initialize do |borrowing_trip|
      borrowing_trip.max_durition_days = trip_max_durition_days
      borrowing_trip.max_single_durition_days = trip_max_single_durition_days
      borrowing_trip.max_borrowings_count = trip_max_borrowings_count
    end

    book.current_holding.borrowing_trip = @borrowing_trip
  end

  def init_attributes_from_borrowing_trip
    self.trip_max_single_durition_days ||= @borrowing_trip.max_single_durition_days
    self.trip_max_durition_days ||= @borrowing_trip.max_durition_days
    self.trip_max_borrowings_count ||= @borrowing_trip.max_borrowings_count
  end

  def assign_attributes_to_borrowing_trip
    @borrowing_trip.max_durition_days = trip_max_durition_days
    @borrowing_trip.max_single_durition_days = trip_max_single_durition_days
    @borrowing_trip.max_borrowings_count = trip_max_borrowings_count
  end

  def save_borrowing_trip
    @borrowing_trip.save!
    book.current_holding.reload
  end

  def prepare_borrowing_invitation
    @borrowing_invitation = Book::BorrowingInvitation.where(holding: book.current_holding).first_or_initialize
  end

  def save_borrowing_invitation
    @borrowing_invitation.save!
  end

  def assign_borrowing_invitation_for_borrowing_invitation_users
    invitation_users.each do |invitation_user|
      invitation_user.borrowing_invitation = @borrowing_invitation
    end
  end

  def validate_book_is_holding_by_owner
    return if book&.holder == book&.owner
    errors.add(:book, :is_not_holding_by_owner)
  end
end
