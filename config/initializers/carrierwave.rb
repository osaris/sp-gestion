# -*- encoding : utf-8 -*-
CarrierWave.configure do |config|
  if Rails.env.production?
    config.storage = :fog
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => SPG_CONFIG['fog']['aws_access_key_id'],
      :aws_secret_access_key  => SPG_CONFIG['fog']['aws_secret_access_key'],
      :region                 => SPG_CONFIG['fog']['region']
    }
    config.fog_directory  = SPG_CONFIG['fog']['directory']
    config.asset_host     = "http://#{SPG_CONFIG['fog']['directory']}"
    config.fog_public     = true
    config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}
  else
    config.storage = :file
    config.enable_processing = false
  end
end