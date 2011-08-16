class AddVehiclePhotoUrlToVehicles < ActiveRecord::Migration
  def self.up
    add_column(:vehicles, :vehicle_photo, :string)
  end

  def self.down
    remove_column(:vehicles, :vehicle_photo)
  end
end
