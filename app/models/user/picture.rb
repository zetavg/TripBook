# frozen_string_literal: true
class User
  class Picture < ApplicationRecord
    mount_uploader :image, UserPictureUploader

    belongs_to :user

    validates :secure_token, uniqueness: true
  end
end
