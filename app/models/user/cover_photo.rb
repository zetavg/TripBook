# frozen_string_literal: true
class User
  class CoverPhoto < ApplicationRecord
    mount_uploader :image, ImageUploader

    belongs_to :user

    validates :secure_token, uniqueness: true
  end
end
