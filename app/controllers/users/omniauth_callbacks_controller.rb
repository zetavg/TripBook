# frozen_string_literal: true
module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def facebook
      auth = request.env["omniauth.auth"]
      access_token = auth.credentials.token
      access_token_expires_at = auth.credentials.expires_at

      id = auth.uid
      email = auth.info.email
      name = auth.info.name

      gender = auth.extra&.raw_info&.gender
      picture_url = auth.extra&.raw_info&.picture&.data&.url
      cover_photo_url = auth&.extra&.raw_info&.cover&.source

      @user = User.from_facebook(
        id: id,
        email: email,
        name: name,
        access_token: access_token,
        access_token_expires_at: access_token_expires_at,
        gender: gender,
        picture_url: picture_url,
        cover_photo_url: cover_photo_url,
        find_possible_user: false # TODO: [1] Set this to true
      )

      if @user.unauthenticated_from_facebook
        # TODO: [1] Ask the user to enter their password and link existing account with facebook account
      elsif @user.new_from_facebook
        sign_in @user
        # TODO: Confirm the commonly used email with the user
        redirect_to root_path
      else
        sign_in @user
        redirect_to root_path
      end
    end

    def failure
      redirect_to root_path
    end
  end
end
