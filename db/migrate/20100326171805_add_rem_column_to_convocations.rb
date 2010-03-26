class AddRemColumnToConvocations < ActiveRecord::Migration
  def self.up
    add_column(:convocations, :rem, :text)
  end

  def self.down
    remove_column(:convocations, :rem)
  end
end
