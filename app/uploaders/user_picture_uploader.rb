# frozen_string_literal: true
class UserPictureUploader < ImageUploader
  include CarrierWave::MiniMagick

  version :small do
    process resize_to_fill: [128, 128]
  end

  version :medium do
    process resize_to_fill: [256, 256]
  end

  version :large do
    process resize_to_fill: [512, 512]
  end
end
