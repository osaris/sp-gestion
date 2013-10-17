class AddPlaceToCheckListsItems < ActiveRecord::Migration
  def self.up
    add_column(:items, :place, :string)
  end

  def self.down
    remove_column(:items, :place, :string)
  end
end
