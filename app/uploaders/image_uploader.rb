# frozen_string_literal: true
class ImageUploader < BaseUploader
  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  process :store_dimensions

  private

  def store_dimensions
    return unless file && model
    model.width, model.height = ::MiniMagick::Image.open(file.file)[:dimensions]
  end

  def secure_token
    model.secure_token ||= SecureRandom.hex(32)
  end
end
