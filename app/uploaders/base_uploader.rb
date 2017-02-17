# frozen_string_literal: true
class BaseUploader < CarrierWave::Uploader::Base
  storage :file
  # storage :fog

  def store_dir
    "storage/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
