# frozen_string_literal: true
class Book::BorrowDemand::WithDemandUser < ActiveType::Object
  nests_one :user, scope: proc { User.all }
  nests_one :book_info, scope: proc { BookInfo.all }
  nests_one :demand_user, scope: proc { User.all }

  attribute :message, :string
  attribute :demand_user_message, :string

  attr_accessor :borrow_demand
  attr_accessor :borrow_demand_demand_user

  delegate :id, to: :user, prefix: true, allow_nil: true
  delegate :isbn, to: :book_info, prefix: true, allow_nil: true
  delegate :id, to: :demand_user, prefix: true, allow_nil: true

  validates :user, :book_info, :demand_user, presence: true
  validates :borrow_demand, :borrow_demand_demand_user, presence: true

  after_initialize :find_or_build_borrow_demand
  after_initialize :find_or_build_borrow_demand_demand_user
  before_validation :find_or_build_borrow_demand
  before_validation :find_or_build_borrow_demand_demand_user

  before_save :set_messages
  before_save :save_borrow_demand
  before_save :save_borrow_demand_demand_user

  def user_id=(id)
    self.user = id && User.find(id)
  end

  def book_info_isbn=(isbn)
    self.book_info = isbn && BookInfo.find(isbn)
  end

  alias book_isbn book_info_isbn
  alias book_isbn= book_info_isbn=

  def demand_user_id=(id)
    self.demand_user = id && User.find(id)
  end

  private

  def find_or_build_borrow_demand
    return unless user_id.present? && book_isbn.present?
    found_or_builded_borrow_demand =
      Book::BorrowDemand.active.where(user_id: user_id, book_isbn: book_isbn).first_or_initialize
    return if borrow_demand.present? && borrow_demand.id == found_or_builded_borrow_demand.id
    self.borrow_demand = found_or_builded_borrow_demand
    self.message ||= borrow_demand.message
  end

  def find_or_build_borrow_demand_demand_user
    return unless borrow_demand.present? && demand_user_id.present?
    found_or_builded_borrow_demand_demand_user = nil

    borrow_demand_demand_users_association = borrow_demand.send :association_instance_get, :demand_users

    if (
      unsaved_borrow_demand_demand_users =
        borrow_demand_demand_users_association &&
        Array.wrap(borrow_demand_demand_users_association.target)
    )
      found_or_builded_borrow_demand_demand_user =
        unsaved_borrow_demand_demand_users.find { |obj| obj.user_id == demand_user_id }
    end

    found_or_builded_borrow_demand_demand_user ||=
      borrow_demand.demand_users.where(user_id: demand_user_id).first_or_initialize

    return if borrow_demand_demand_user.present? &&
              borrow_demand_demand_user.id == found_or_builded_borrow_demand_demand_user.id
    self.borrow_demand_demand_user = found_or_builded_borrow_demand_demand_user
    self.demand_user_message ||= borrow_demand_demand_user.message
  end

  def set_messages
    borrow_demand.message = message
    borrow_demand_demand_user.message = demand_user_message
  end

  def save_borrow_demand
    borrow_demand.save!
  end

  def save_borrow_demand_demand_user
    borrow_demand_demand_user.save!
  end
end
