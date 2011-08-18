class AddItemPhotoUrlToItems < ActiveRecord::Migration
  def self.up
    add_column(:items, :item_photo, :string)
  end

  def self.down
    remove_column(:items, :item_photo)
  end
end
