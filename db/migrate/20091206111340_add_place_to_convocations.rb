class AddPlaceToConvocations < ActiveRecord::Migration
  def self.up
    add_column(:convocations, :place, :string)
  end

  def self.down
    remove_column(:convocations, :place)
  end
end
