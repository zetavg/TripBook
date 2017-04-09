# frozen_string_literal: true
class BaseUploader < CarrierWave::Uploader::Base
  if fog_credentials.present?
    storage :fog
  else
    storage :file
  end

  def store_dir
    "storage/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
