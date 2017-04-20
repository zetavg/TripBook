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

  USERNAME_REGEXP = /\A[0-9A-Za-z_]+\Z/

  has_one :picture, -> { reorder(provider: :desc, updated_at: :desc) }
  has_one :cover_photo, -> { reorder(provider: :desc, updated_at: :desc) }
  has_many :pictures
  has_many :cover_photos

  validates :name, presence: true
  validates :username, uniqueness: { case_sensitive: false },
                       format: { with: USERNAME_REGEXP, message: '只能包含英文字母和數字' },
                       allow_nil: true

  before_validation :nilify_blanks

  def display_name
    username || name
  end

  private

  def nilify_blanks
    self.username = username.presence
  end
end
