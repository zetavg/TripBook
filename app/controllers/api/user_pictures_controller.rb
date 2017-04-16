# frozen_string_literal: true
class API::UserPicturesController < ApplicationController
  def create
    if image_params[:image].present?
      @user_picture = User::Picture.new(image_params)

      if @user_picture.save
        render status: 201
      else
        render status: 500, json: { error: "upload_error" }
      end
    else
      render status: 400, json: { error: "no_image_file" }
    end
  end

  private

  def image_params
    params.require(:user_picture).permit(:image)
  end
end
