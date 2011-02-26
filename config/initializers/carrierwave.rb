CarrierWave.configure do |config|
  config.s3_access_key_id = "AKIAI3DSGZI62YJTITAQ"
  config.s3_secret_access_key = "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"
  config.s3_bucket = "s3.sp-gestion.fr"

  config.s3_access_policy = :public_read

  config.s3_cnamed = true
  config.s3_bucket = "s3.sp-gestion.fr"

  config.s3_region = 'eu-west-1'
end