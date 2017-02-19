# frozen_string_literal: true
class User < ApplicationRecord
  include Profileable
  include FacebookAuthenticatable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  has_one :picture
  has_one :cover_photo
  has_many :owned_books, class_name: 'Book', foreign_key: :owner_id
  has_many :holdings, class_name: 'BookHolding'
  has_many :past_holded_books, through: :holdings, source: :book
  has_many :active_holdings, -> { active }, class_name: 'BookHolding'
  has_many :holding_books, through: :active_holdings, source: :book
  has_one :facebook_account

  validates :name, presence: true
end
