# -*- encoding : utf-8 -*-
class BaseUploader < CarrierWave::Uploader::Base

  # Include RMagick or ImageScience support
  # include CarrierWave::RMagick
  # include CarrierWave::ImageScience
  include CarrierWave::MiniMagick

  # Include the sprockets-rails helper for Rails 4+ asset pipeline compatibility:
  include Sprockets::Rails::Helper

  # Override the directory where uploaded files will be stored
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{Digest::SHA1.hexdigest(model.id.to_s)}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded
  #     def default_url
  #       "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  #     end

  # Process files as they are uploaded.
  #     process :scale => [200, 300]
  #
  #     def scale(width, height)
  #       # do something
  #     end

  process :convert => 'png'

  # Add a white list of extensions which are allowed to be uploaded,
  # for images you might use something like this:
  def extension_white_list
    %w(jpg jpeg png)
  end

  # Override the filename of the uploaded files
  def filename
    "file.png" if original_filename
  end
end
