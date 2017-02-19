# frozen_string_literal: true
class BookCoverImageUploader < ImageUploader
  include CarrierWave::MiniMagick

  def filename
    "cover.#{file.extension}" if original_filename.present?
  end

  version :thumbnail do
    process resize_to_fit: [256, 256]
  end

  version :medium do
    process resize_to_fit: [1024, 1024]
  end
end
