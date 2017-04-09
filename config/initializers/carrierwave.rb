# frozen_string_literal: true
if Config.aws_s3.access_key_id.present?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     Config.aws_s3.access_key_id,
      aws_secret_access_key: Config.aws_s3.secret_access_key,
      region:                Config.aws_s3.region
    }
    config.fog_directory = Config.aws_s3.bucket
    config.asset_host = Config.aws_s3.asset_host
  end
end
