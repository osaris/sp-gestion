# encoding: utf-8

class LogoUploader < CarrierWave::Uploader::Base

  # Include RMagick or ImageScience support
  include CarrierWave::RMagick
  # include CarrierWave::ImageScience

  # Choose what kind of storage to use for this uploader
  storage :s3

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
  process :resize_and_pad => [100, 50]

  # Add a white list of extensions which are allowed to be uploaded,
  # for images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files
  def filename
    "logo.png" if original_filename
  end

end
