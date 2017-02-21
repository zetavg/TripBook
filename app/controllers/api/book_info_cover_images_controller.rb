# frozen_string_literal: true
class API::BookInfoCoverImagesController < API::APIController
  def create
    if image_params[:image].present?
      @book_info_cover_image = BookInfo::CoverImage.new(image_params)

      if @book_info_cover_image.save
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
    params.require(:book_info_cover_image).permit(:image)
  end
end
