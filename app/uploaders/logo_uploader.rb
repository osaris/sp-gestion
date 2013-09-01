# -*- encoding : utf-8 -*-
class LogoUploader < BaseUploader

  process :resize_and_pad => [100, 50]

  # Override the filename of the uploaded files
  def filename
    "logo.png" if original_filename
  end

end