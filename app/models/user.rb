# frozen_string_literal: true
class User < ApplicationRecord
  include Profileable
  include BookRelations
  include BookBorrowingRelations
  include FacebookAuthenticatable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  has_one :picture
  has_one :cover_photo
  has_one :facebook_account

  validates :name, presence: true
  validates :username, uniqueness: true

  def username
    self[:username] || name
  end
end
