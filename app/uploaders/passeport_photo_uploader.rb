# -*- encoding : utf-8 -*-
class PasseportPhotoUploader < BaseUploader

  process :resize_and_pad => [155, 200]

  version :thumb do
    process :resize_to_fill => [50, 65]
  end

  # Override the filename of the uploaded files
  def filename
    "passeport_photo.png" if original_filename
  end

  def default_url
    "/images/back/" + [version_name, "default_passeport_photo.png"].compact.join('_')
  end

end