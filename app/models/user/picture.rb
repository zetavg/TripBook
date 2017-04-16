# frozen_string_literal: true
class User
  class Picture < ApplicationRecord
    mount_uploader :image, UserPictureUploader

    belongs_to :user

    validates :secure_token, uniqueness: true

    before_validation :ensure_user_id_not_changed_for_provided_picture

    private

    def ensure_user_id_not_changed_for_provided_picture
      return if provider.blank?
      return unless user_id_changed?
      self.user_id = user_id_was
    end
  end
end
