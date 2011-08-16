# -*- encoding : utf-8 -*-
class VehiclePhotoUploader < BaseUploader

  process :resize_and_pad => [480, 360]
  
  # Override the filename of the uploaded files
  def filename
    "vehicle.png" if original_filename
  end

  def default_url
    "/images/back/" + [version_name, "default_vehicle_photo.png"].compact.join('_')
  end

end