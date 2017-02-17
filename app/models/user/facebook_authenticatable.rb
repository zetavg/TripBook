# frozen_string_literal: true
class User
  module FacebookAuthenticatable
    extend ActiveSupport::Concern

    included do
      attr_accessor :from_facebook
      attr_accessor :new_from_facebook
      attr_accessor :unauthenticated_from_facebook
    end

    class_methods do
      def from_facebook(
        access_token:, access_token_expires_at:,
        id:, email:, name:,
        gender: nil,
        picture_url: nil,
        cover_photo_url: nil,
        find_possible_user: false
      )

        facebook_account = FacebookAccount.find_and_update_or_create_by(
          id: id,
          email: email,
          name: name,
          picture_url: picture_url,
          cover_photo_url: cover_photo_url,
          access_token: access_token,
          access_token_expires_at: access_token_expires_at
        )

        if facebook_account.user.blank? && find_possible_user
          # TODO: Link existing users with their FB account
          # possible_user = User.find_by(email: email)
          # if possible_user
          #   possible_user.from_facebook = true
          #   possible_user.from_facebook_unauthenticated = true
          #   possible_user.facebook_account = facebook_account
          #   return possible_user
          # end
        end

        user = facebook_account.user || facebook_account.create_user!(
          new_from_facebook: true,
          email: email,
          password: SecureRandom.hex(32),
          name: name,
          confirmed_at: Time.current,
          gender: %w(male female).include?(gender) ? gender : :other
        )

        user.create_picture!(remote_image_url: picture_url) if user.picture.blank?
        user.create_cover_photo!(remote_image_url: cover_photo_url) if user.cover_photo.blank?

        user.from_facebook = true
        user
      end
    end
  end
end
