AssetSync.configure do |config|
  config.fog_provider = 'AWS'
  config.aws_access_key_id = SPG_CONFIG[:fog][:aws_access_key_id]
  config.aws_secret_access_key = SPG_CONFIG[:fog][:aws_secret_access_key]
  config.fog_directory = SPG_CONFIG[:fog][:directory]

  # Increase upload performance by configuring your region
  config.fog_region = SPG_CONFIG[:fog][:region]

  # Don't delete files from the store
  config.existing_remote_files = "delete"

  # Automatically replace files with their equivalent gzip compressed version
  # config.gzip_compression = true

  # Use the Rails generated 'manifest.yml' file to produce the list of files to
  # upload instead of searching the assets directory.
  config.manifest = true
end

# Fix bug with SSL certificate verification failing with dot in bucket name
Fog.credentials = { path_style: true }