class AddConfirmableToConvocation < ActiveRecord::Migration
  def self.up
    add_column(:convocations, :confirmable, :boolean)
  end

  def self.down
    remove_column(:convocations, :confirmable)
  end
end
