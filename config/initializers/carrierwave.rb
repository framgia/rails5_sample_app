CarrierWave.configure do |config|
  if Rails.env.development? || Rails.env.test?
    config.storage :file
  else
    config.fog_credentials = {
      provider:                "AWS",
      aws_access_key_id:       ENV["AWS_ACCESS_KEY_ID"],
      aws_secret_access_key:   ENV["AWS_SECRET_ACCESS_KEY"],
      region:                  ENV["AWS_REGION"],
      path_style:              true
    }
    config.storage :fog
    config.fog_directory  = ENV['S3_BUCKET_NAME']
    config.fog_public = Settings.carrierwave.fog_public
    config.fog_authenticated_url_expiration = eval(Settings.carrierwave.fog_expiration)
    config.fog_attributes = {
      "Cache-Control" => "max-age=#{eval(Settings.carrierwave.fog_cache_control).to_i}"
    }
    config.asset_host = ENV["CLOUDFRONT_DOMAIN_NAME"]
  end
end
