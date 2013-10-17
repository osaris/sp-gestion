class AddPasseportPhotoUrlToFiremen < ActiveRecord::Migration
  def self.up
    add_column(:firemen, :passeport_photo, :string)
  end

  def self.down
    remove_column(:firemen, :passeport_photo)
  end
end