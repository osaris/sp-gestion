class AddSubtypeToInterventions < ActiveRecord::Migration
  def self.up
    add_column(:interventions, :subtype, :string)
  end

  def self.down
    remove_column(:interventions, :subtype, :string)
  end
end
