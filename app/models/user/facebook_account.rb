# frozen_string_literal: true
class User
  class FacebookAccount < ApplicationRecord
    belongs_to :user, optional: true

    def self.find_and_update_or_create_by(
      id:,
      email: nil, name: nil,
      picture_url: nil, cover_photo_url: nil,
      access_token: nil, access_token_expires_at: nil
    )
      facebook_account = find_or_initialize_by(facebook_id: id)

      facebook_account.email = email if email.present?
      facebook_account.name = name if name.present?
      facebook_account.picture_url = picture_url if picture_url.present?
      facebook_account.cover_photo_url = cover_photo_url if cover_photo_url.present?

      if access_token.present? && access_token_expires_at.present?
        if (facebook_account.access_token_expires_at || 0) < access_token_expires_at
          facebook_account.assign_attributes(
            access_token: access_token,
            access_token_expires_at: access_token_expires_at
          )
        end
      end

      facebook_account.save!

      facebook_account
    end

    def url
      "https://www.facebook.com/#{facebook_id}"
    end
  end
end
