# frozen_string_literal: true
class BookCoverImageUploader < ImageUploader
  include CarrierWave::MiniMagick

  version :thumbnail do
    process resize_to_fit: [256, 256]
  end

  version :medium do
    process resize_to_fit: [1024, 1024]
  end
end
