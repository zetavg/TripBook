# frozen_string_literal: true
class User
  module FacebookAuthenticatable
    extend ActiveSupport::Concern

    included do
      attr_accessor :from_facebook
      attr_accessor :new_from_facebook
      attr_accessor :unauthenticated_from_facebook
    end

    def from_facebook?
      from_facebook.is_a? TrueClass
    end

    def new_from_facebook?
      new_from_facebook.is_a? TrueClass
    end

    def unauthenticated_from_facebook?
      unauthenticated_from_facebook.is_a? TrueClass
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
          possible_user = User.find_by(email: email)
          if possible_user
            possible_user.from_facebook = true
            possible_user.unauthenticated_from_facebook = true
            possible_user.facebook_account = facebook_account
            return possible_user
          end
        end

        user = facebook_account.user || facebook_account.create_user!(
          new_from_facebook: true,
          email: email,
          password: SecureRandom.hex(32),
          name: name,
          confirmed_at: Time.current,
          gender: %w(male female).include?(gender) ? gender : :other
        )

        if picture_url.present?
          user.create_picture(
            remote_image_url: picture_url,
            secure_token: Digest::MD5.hexdigest(picture_url)[0..200],
            provider: :facebook
          )
        end

        if cover_photo_url.present?
          user.create_cover_photo(
            remote_image_url: cover_photo_url,
            secure_token: Digest::MD5.hexdigest(picture_url)[0..200],
            provider: :facebook
          )
        end

        user.from_facebook = true
        user
      end
    end
  end
end
