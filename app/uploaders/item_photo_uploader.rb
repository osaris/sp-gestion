# -*- encoding : utf-8 -*-
class ItemPhotoUploader < BaseUploader

  process :resize_and_pad => [480, 360]

  # Override the filename of the uploaded files
  def filename
    "item.png" if original_filename
  end

  def default_url
    asset_path("back/" + [version_name, "default_photo_480_360.png"].compact.join('_'))
  end

end