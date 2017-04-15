# frozen_string_literal: true
class User < ApplicationRecord
  include Profileable
  include Trackable
  include BookRelations
  include BookBorrowingRelations
  include FacebookAuthenticatable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  has_one :picture, -> { reorder(updated_at: :desc) }
  has_one :cover_photo, -> { reorder(updated_at: :desc) }
  has_one :facebook_account

  validates :name, presence: true
  validates :username, uniqueness: true

  def username
    self[:username] || name
  end
end
